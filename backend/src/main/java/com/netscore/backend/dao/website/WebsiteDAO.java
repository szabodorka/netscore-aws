package com.netscore.backend.dao.website;

import com.netscore.backend.dao.model.website.NewWebsite;
import com.netscore.backend.dao.model.website.Website;

import java.util.List;

public interface WebsiteDAO {
    List<Website> getAllWebsites();
    Website getWebsite(int id);
    int createWebsite(NewWebsite website);
    void deleteWebsite(int id);
    List<Website> getSearchedWebsites(String searchTerm);
}
