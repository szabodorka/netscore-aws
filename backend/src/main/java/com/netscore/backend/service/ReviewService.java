package com.netscore.backend.service;


import com.netscore.backend.controller.dto.review.NewReviewDTO;
import com.netscore.backend.controller.dto.review.ReviewDTO;
import com.netscore.backend.dao.model.review.NewReview;
import com.netscore.backend.dao.model.review.Review;
import com.netscore.backend.dao.review.ReviewDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class ReviewService {

    private final ReviewDAO reviewDAO;

    @Autowired
    public ReviewService(ReviewDAO reviewDAO) {
        this.reviewDAO = reviewDAO;
    }

    public List<ReviewDTO> getReviewsByWebsiteId(int id) {
        try {
            List<Review> reviews = reviewDAO.getAllReviewsByWebsiteId(id);
            List<ReviewDTO> reviewDTOs = new ArrayList<>();
            for (Review review : reviews) {
                reviewDTOs.add(new ReviewDTO(
                        review.id(),
                        review.score(),
                        review.comment(),
                        review.userId(),
                        review.postDate(),
                        review.websiteId()
                ));
            }
            return reviewDTOs;
        } catch (RuntimeException e) {
            throw new RuntimeException("Error while getting all reviews by website id", e);
        }
    }

    public List<ReviewDTO> getReviewsByUserId(int id) {
        try {
            List<Review> reviews = reviewDAO.getAllReviewsByUserId(id);
            List<ReviewDTO> reviewDTOs = new ArrayList<>();
            for (Review review : reviews) {
                reviewDTOs.add(new ReviewDTO(
                        review.id(),
                        review.score(),
                        review.comment(),
                        review.userId(),
                        review.postDate(),
                        review.websiteId()
                ));
            }
            return reviewDTOs;
        } catch (RuntimeException e) {
            throw new RuntimeException("Error while getting all reviews by user id", e);
        }
    }


    public ReviewDTO getReviewById(int id) {
        try {
            Review review = reviewDAO.getReview(id);
            return new ReviewDTO(
                    review.id(),
                    review.score(),
                    review.comment(),
                    review.userId(),
                    review.postDate(),
                    review.websiteId()
            );
        } catch (RuntimeException e) {
            throw new RuntimeException("Error while getting review by id", e);
        }
    }

    public void deleteReviewById(int id) {
        try {
            reviewDAO.deleteReview(id);
        } catch (RuntimeException e) {
            throw new RuntimeException("Error while deleting review", e);
        }
    }

    public int addNewReview(NewReviewDTO newReviewDTO) {
        try {
            NewReview newReview = new NewReview(
                    newReviewDTO.score(),
                    newReviewDTO.comment(),
                    newReviewDTO.userId(),
                    newReviewDTO.websiteId()
            );

            return reviewDAO.createReview(newReview);
        } catch (RuntimeException e) {
            throw new RuntimeException("Error while adding new review", e);
        }
    }
}


