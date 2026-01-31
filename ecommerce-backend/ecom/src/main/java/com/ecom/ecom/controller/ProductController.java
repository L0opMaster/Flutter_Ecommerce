package com.ecom.ecom.controller;

import com.ecom.ecom.model.Product;
import com.ecom.ecom.model.Role;
import com.ecom.ecom.model.User;
import com.ecom.ecom.repository.ProductRepository;
import com.ecom.ecom.repository.UserRepository;
import com.ecom.ecom.service.ProductService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/products")
public class ProductController {

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ProductService productService;

    // Get all products (USER,ADMIN)
    @GetMapping("/all")
    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }

    // Admin only create product
    @PostMapping("/create")
    public ResponseEntity<?> createProduct(@RequestBody Product product, @RequestParam String email) {
        try{
            User user = userRepository.findByEmail(email);
            if (user == null || user.getRole() != Role.ADMIN) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Access denied");
            }

            product.setId(null); // important, ignore frontend id
            Product saved = productService.createProduct(product, email);
            return ResponseEntity.status(HttpStatus.CREATED).body(saved);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage()); 
        }

    }
    // Admin-only update product
    @PutMapping("/update/{id}")
    public ResponseEntity<?> updateProduct(@PathVariable Integer id, @RequestBody Product product, @RequestParam String email) {
        try{
            User user = userRepository.findByEmail(email);
            if (user == null || user.getRole() != Role.ADMIN) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Access denied");
            }
            Product update = productService.updateProduct(id, product, email);
            return ResponseEntity.ok(update);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }

    }


    // Admin-only delete product
    @DeleteMapping("/delete/{id}")
    public ResponseEntity<?> deleteProduct(@PathVariable Integer id, @RequestParam String email) {
        User user = userRepository.findByEmail(email);
        if (user == null || user.getRole() != Role.ADMIN) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Access denied");
        }
        if (!productRepository.existsById(id)) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Product not found");
        }
        productRepository.deleteById(id);
        return ResponseEntity.ok("Deleted successfully");
    }
}
