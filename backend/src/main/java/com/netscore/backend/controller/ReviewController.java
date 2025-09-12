package com.netscore.backend.controller;

import com.netscore.backend.controller.dto.review.NewReviewDTO;
import com.netscore.backend.controller.dto.review.ReviewDTO;
import com.netscore.backend.service.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("api/review")
public class ReviewController {
    private final ReviewService reviewService;

    @Autowired
    public ReviewController(ReviewService reviewService) {
        this.reviewService = reviewService;
    }


    @GetMapping("/{id}")
    public ReviewDTO getReviewById(@PathVariable int id) {
        return reviewService.getReviewById(id);
    }

    @GetMapping("/website/{websiteId")
    public List<ReviewDTO> getReviewsByWebsite(@PathVariable int websiteId) {
        return reviewService.getReviewsByWebsiteId(websiteId);
    }

    @PostMapping("/")
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<Integer> addNewReview(@RequestBody NewReviewDTO newReviewDTO) {
        int id = reviewService.addNewReview(newReviewDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(id);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteReviewById(@PathVariable int id) {
        reviewService.deleteReviewById(id);
    }
}
