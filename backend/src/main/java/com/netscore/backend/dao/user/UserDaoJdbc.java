package com.netscore.backend.dao.user;

import com.netscore.backend.dao.model.user.NewUser;
import com.netscore.backend.dao.model.user.User;

import javax.sql.DataSource;
import java.sql.*;
import java.time.LocalDateTime;


public class UserDaoJdbc implements UserDAO {
    private final DataSource dataSource;

    public UserDaoJdbc(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Override
    public User getUser(int id){
        try (Connection connection = dataSource.getConnection()){
            String sql = "SELECT * FROM \"user\" WHERE id = ?";
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, id);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                String username = resultSet.getString("username");
                LocalDateTime registration_date = resultSet.getTimestamp("registration_date").toLocalDateTime();
                return new User(id, username, registration_date);
            } else {
                return null;
            }
        } catch (SQLException e){
            throw new RuntimeException("Error while reading user", e);
        }
    }

    @Override
    public int createUser(NewUser newUser){
        try(Connection connection = dataSource.getConnection()) {
            String sql = "INSERT INTO \"user\" (username, password) VALUES (?, ?)";
            PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, newUser.username());
            statement.setString(2, newUser.password());
            statement.executeUpdate();
            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                } else {
                    throw new SQLException("Error while retrieving new user ID.");
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error while adding new user", e);
        }
    }

    @Override
    public void deleteUser(int id){
        try(Connection connection = dataSource.getConnection()) {
            String sql = "DELETE FROM \"user\" WHERE id = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error while deleting user", e);
        }
    }

    @Override
    public boolean existsByUsername(String username){
        String sql = "SELECT * FROM \"user\" WHERE username = ?;";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)
        ) {
            pst.setString(1, username);
            ResultSet rs = pst.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            throw new RuntimeException("SQL Error: failed username validation.", e);
        }
    }

    @Override
    public boolean passwordMatchesById(int id, String password){
        String sql = "SELECT * FROM \"user\" WHERE id = ? AND password = ?;";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)
        ) {
            pst.setInt(1, id);
            pst.setString(2, password);
            ResultSet rs = pst.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            throw new RuntimeException("SQL Error: failed password validation.", e);
        }
    }

    @Override
    public int getUserIdByUsername(String username){
        String sql = "SELECT id FROM \"user\" WHERE username = ?;";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)
        ) {
            pst.setString(1, username);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                return rs.getInt("id");
            } else {
                return -1;
            }
        } catch (SQLException e) {
            throw new RuntimeException("SQL Error: could not get user.", e);
        }
    }

    @Override
    public boolean existsById(int id){
        String sql = "SELECT * FROM \"user\" WHERE id = ?;";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)
        ) {
            pst.setInt(1, id);
            ResultSet rs = pst.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            throw new RuntimeException("SQL Error: failed username validation.", e);
        }
    }
}



