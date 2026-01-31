package com.ecom.ecom.service;

import com.ecom.ecom.model.Product;
import com.ecom.ecom.model.Role;
import com.ecom.ecom.model.User;
import com.ecom.ecom.repository.ProductRepository;
import com.ecom.ecom.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

import javax.management.RuntimeErrorException;

@Service
public class ProductService {

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private UserRepository userRepository;

    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }


    public Product createProduct(Product product, String adminEmail) {
        validateAdmin(adminEmail);
        if(productRepository.existsByName(product.getName())){
            throw new RuntimeException("Product name already exists");
        }
        return productRepository.save(product);
    }

    public Product updateProduct(Integer id, Product product, String adminEmail) {
        validateAdmin(adminEmail);
        
        Product products = productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found"));
        if (productRepository.existsByName(product.getName())) {
            throw new RuntimeException("Product name already exists");
        }
        products.setName(product.getName());
        products.setDescription(product.getDescription());
        products.setPrice(product.getPrice());
        products.setImageUrl(product.getImageUrl());
        products.setStock(product.getStock());

        return productRepository.save(product);
    }

    // ADMIN
    public void deleteProduct(Integer id, String adminEmail) {
        validateAdmin(adminEmail);
        productRepository.deleteById(id);
    }

    private void validateAdmin(String email) {
        User admin = userRepository.findByEmail(email);

        if (admin == null || admin.getRole() != Role.ADMIN) {
            throw new RuntimeException("Admin access required");
        }
    }
}

