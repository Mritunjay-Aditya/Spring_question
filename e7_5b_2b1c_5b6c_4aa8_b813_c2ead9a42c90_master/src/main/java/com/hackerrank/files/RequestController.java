package com.hackerrank.files;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.springframework.core.io.FileSystemResource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
public class RequestController {
    public static final String UPLOAD_DIR = "uploads/";

    @PostMapping("/uploader")
    public ResponseEntity uploader(@RequestParam("fileName") String fileName, @RequestParam("file") MultipartFile file) throws IOException {
        Path fileUpload=Paths.get(UPLOAD_DIR,fileName);
        Files.write(fileUpload,file.getBytes());
        return new ResponseEntity<>(fileUpload,HttpStatus.CREATED);
    }

    @GetMapping("/downloader")
    public ResponseEntity downloader(@RequestParam String fileName) {
    	Path fileUpload=Paths.get(UPLOAD_DIR,fileName);
    	File file=fileUpload.toFile();
    	if(!file.exists()) {
    		return ResponseEntity.badRequest().build();
    	}
    	return ResponseEntity.ok(new FileSystemResource(file));
    	
    }
}
