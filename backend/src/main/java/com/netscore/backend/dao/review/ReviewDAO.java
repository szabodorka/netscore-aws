package com.netscore.backend.dao.review;

import com.netscore.backend.dao.model.review.NewReview;
import com.netscore.backend.dao.model.review.Review;

import java.util.List;

public interface ReviewDAO {
    List<Review> getAllReviewsByWebsiteId();
    Review getReview(int id);
    void createReview(NewReview newReview);
    void deleteReview(int id);
}