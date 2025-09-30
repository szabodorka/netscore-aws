package com.netscore.backend.configuration;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringBootConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import com.netscore.backend.dao.review.ReviewDAO;
import com.netscore.backend.dao.review.ReviewDaoJdbc;
import com.netscore.backend.dao.user.UserDAO;
import com.netscore.backend.dao.user.UserDaoJdbc;
import com.netscore.backend.dao.website.WebsiteDAO;
import com.netscore.backend.dao.website.WebsiteDaoJdbc;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;


import javax.sql.DataSource;

@SpringBootConfiguration
public class Configuration {

    //  TODO: Add the url of your database to the Environment Variables of the Run Configuration
    @Value("${netscore.database.url}")
    private String databaseUrl;

    @Value("${netscore.database.username}")
    private String databaseUsername;

    @Value("${netscore.database.password}")
    private String databasePassword;

    @Bean
    public DataSource dataSource() {
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName("org.postgresql.Driver");
        dataSource.setUrl(databaseUrl);
        dataSource.setUsername(databaseUsername);
        dataSource.setPassword(databasePassword);
        return dataSource;
    }

    @Bean
    public ReviewDAO reviewDAO(DataSource dataSource) {
        return new ReviewDaoJdbc(dataSource);
    }

    @Bean
    public WebsiteDAO websiteDAO(DataSource dataSource) {
        return new WebsiteDaoJdbc(dataSource);
    }

    @Bean
    public UserDAO userDAO(DataSource dataSource) {
        return new UserDaoJdbc(dataSource);
    }

    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

}
