package com.netscore.backend.dao.review;

import com.netscore.backend.dao.model.review.NewReview;
import com.netscore.backend.dao.model.review.Review;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class ReviewDaoJdbc implements ReviewDAO {
    private final DataSource dataSource;

    public ReviewDaoJdbc(DataSource dataSource) {
        this.dataSource = dataSource;
    }


    @Override
    public List<Review> getAllReviewsByWebsiteId(int id) {
        try (Connection connection = dataSource.getConnection()) {
            String sql = "SELECT id, score, comment, user_id, post_date FROM review ORDER BY post_date DESC";
            ResultSet result = connection.createStatement().executeQuery(sql);
            List<Review> allReviews = new ArrayList<>();
            while (result.next()) {
                Review review = new Review(
                        result.getInt("id"),
                        result.getString("score"),
                        result.getString("comment"),
                        result.getInt("user_id"),
                        result.getTimestamp("post_date").toLocalDateTime(),
                        id
                );
                allReviews.add(review);
            }
            return allReviews;
        } catch (SQLException e) {
            throw new RuntimeException("Error while reading all reviews", e);
        }
    }

    @Override
    public Review getReview(int id) {
        try (Connection connection = dataSource.getConnection()){
            String sql = "SELECT * FROM review WHERE id = ?";
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, id);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                return new Review(
                        id,
                        resultSet.getString("score"),
                        resultSet.getString("comment"),
                        resultSet.getInt("user_id"),
                        resultSet.getTimestamp("post_date").toLocalDateTime(),
                        resultSet.getInt("website_id")
                );
            } else {
                return null;
            }
        } catch (SQLException e){
            throw new RuntimeException("Error while reading review", e);
        }
    }

    @Override
    public int createReview(NewReview newReview) {
        try(Connection connection = dataSource.getConnection()) {
            String sql = "INSERT INTO review (title, comment, user_id, website_id) VALUES (?, ?, ?, ?)";
            PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, newReview.score());
            statement.setString(2, newReview.comment());
            statement.setInt(3, newReview.userId());
            statement.setInt(4, newReview.websiteId());
            statement.executeUpdate();

            ResultSet rs = statement.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            } else {
                throw new RuntimeException("No generated ID returned");
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error while adding new review", e);
        }
    }

    @Override
    public int deleteReview(int id) {
        try(Connection connection = dataSource.getConnection()) {
            String sql = "DELETE FROM review WHERE id = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            statement.executeUpdate();

            ResultSet rs = statement.getGeneratedKeys();
            if (rs.next()){
                return rs.getInt(1);
            } else {
                throw new RuntimeException("No generated ID returned");
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error while deleting review", e);
        }
    }
}
