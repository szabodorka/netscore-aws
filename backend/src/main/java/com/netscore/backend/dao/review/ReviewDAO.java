package com.netscore.backend.dao.review;

import com.netscore.backend.dao.model.review.NewReview;
import com.netscore.backend.dao.model.review.Review;

import java.util.List;

public interface ReviewDAO {
    List<Review> getAllReviewsByWebsiteId(int id);
    List<Review> getAllReviewsByUserId(int id);
    Review getReview(int id);
    int createReview(NewReview newReview);
    void deleteReview(int id);
}