package com.netscore.backend.dao.website;

import org.springframework.stereotype.Repository;
import com.netscore.backend.dao.model.website.NewWebsite;
import com.netscore.backend.dao.model.website.Website;

import javax.sql.DataSource;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Repository
public class WebsiteDaoJdbc implements WebsiteDAO {
    private final DataSource dataSource;

    public WebsiteDaoJdbc(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Override
    public List<Website> getAllWebsites() {
        try (Connection connection = dataSource.getConnection()) {
            String sql = "SELECT id, domain, name, url, description, user_id, post_date FROM website ORDER BY post_date DESC";
            ResultSet result = connection.createStatement().executeQuery(sql);
            List<Website> allWebsites = new ArrayList<>();
            while (result.next()) {
                Website website = new Website(result.getInt("id"), result.getString("domain"), result.getString("name"), result.getString("url"), result.getString("description"), result.getInt("user_id"), result.getTimestamp("post_date").toLocalDateTime());
                allWebsites.add(website);
            }
            return allWebsites;
        } catch (SQLException e) {
            throw new RuntimeException("Error while reading all websites", e);
        }
    }

    @Override
    public Website getWebsite(int id) {
        try (Connection connection = dataSource.getConnection()){
            String sql = "SELECT * FROM website WHERE id = ?";
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, id);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                int websiteId = resultSet.getInt("id");
                String domain = resultSet.getString("domain");
                String name = resultSet.getString("name");
                String url = resultSet.getString("url");
                String description = resultSet.getString("description");
                int userId = resultSet.getInt("user_id");
                LocalDateTime postDate = resultSet.getTimestamp("post_date").toLocalDateTime();
                return new Website(websiteId, domain, name, url, description, userId, postDate);
            } else {
                return null;
            }
        } catch (SQLException e){
            throw new RuntimeException("Error while reading website", e);
        }
    }

    @Override
    public int createWebsite(NewWebsite website) {
        try(Connection connection = dataSource.getConnection()) {
            String sql = "INSERT INTO website (domain, name, url, description, user_id) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, website.domain());
            statement.setString(2, website.name());
            statement.setString(3, website.url());
            statement.setString(4, website.description());
            statement.setInt(5, website.userId());
            statement.executeUpdate();
            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                } else {
                    throw new SQLException("Error while retrieving new website ID.");
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error while adding new website", e);
        }
    }

    @Override
    public void deleteWebsite(int id) {
        try(Connection connection = dataSource.getConnection()) {
            String sql = "DELETE FROM website WHERE id = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error while deleting website", e);
        }
    }

    @Override
    public List<Website> getSearchedWebsites(String searchTerm) {
        try (Connection connection = dataSource.getConnection()) {
            String sql = "SELECT id, domain, name, url, description, user_id, post_date FROM website WHERE url ILIKE ?";
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, "%" + searchTerm + "%");

            ResultSet result = preparedStatement.executeQuery();

            List<Website> allWebsites = new ArrayList<>();
            while (result.next()) {
                Website website = new Website(
                        result.getInt("id"),
                        result.getString("domain"),
                        result.getString("name"),
                        result.getString("url"),
                        result.getString("description"),
                        result.getInt("user_id"),
                        result.getTimestamp("post_date").toLocalDateTime()
                );
                allWebsites.add(website);
            }
            return allWebsites;
        } catch (SQLException e) {
            throw new RuntimeException("Error while reading searched websites", e);
        }
    }
}
