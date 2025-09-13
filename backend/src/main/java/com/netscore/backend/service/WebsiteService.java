package com.netscore.backend.service;

import com.netscore.backend.controller.dto.website.WebsiteDTO;
import com.netscore.backend.controller.dto.website.NewWebsiteDTO;
import com.netscore.backend.dao.model.website.NewWebsite;
import com.netscore.backend.dao.model.website.Website;
import com.netscore.backend.dao.website.WebsiteDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class WebsiteService {

    private final WebsiteDAO websiteDAO;

    @Autowired
    public WebsiteService(WebsiteDAO websiteDAO) {
        this.websiteDAO = websiteDAO;
    }

    public List<WebsiteDTO> getAllWebsites() {
        try {
            List<Website> allWebsites = websiteDAO.getAllWebsites();
            List<WebsiteDTO> websiteDTOs = new ArrayList<>();
            for (Website website : allWebsites) {
                websiteDTOs.add(new WebsiteDTO(website.id(), website.url(), website.userId(), website.postDate()));
            }
            return websiteDTOs;
        } catch (RuntimeException e) {
            throw new RuntimeException("Error while getting all websites", e);
        }
    }

    public WebsiteDTO getWebsiteById(int id) {
        try {
            Website website = websiteDAO.getWebsite(id);
            return new WebsiteDTO(website.id(), website.url(), website.userId(), website.postDate());
        } catch (RuntimeException e) {
            throw new RuntimeException("Error while getting website by ID", e);
        }
    }

    public void deleteWebsiteById(int id) {
        try {
            websiteDAO.deleteWebsite(id);
        } catch (RuntimeException e) {
            throw new RuntimeException("Error while deleting website", e);
        }
    }

    public int addNewWebsite(NewWebsiteDTO website) {
        try {
            NewWebsite websiteToSave = new NewWebsite(website.url(), website.userId());
            return websiteDAO.createWebsite(websiteToSave);
        } catch (RuntimeException e) {
            throw new RuntimeException("Error while adding new website", e);
        }
    }

    public List<WebsiteDTO> searchWebsitesBySearchTerm(String searchTerm) {
        try {
            List<Website> searchedWebsites = websiteDAO.getSearchedWebsites(searchTerm);
            List<WebsiteDTO> websiteDTOs = new ArrayList<>();
            for (Website website : searchedWebsites) {
                websiteDTOs.add(new WebsiteDTO(website.id(), website.url(), website.userId(), website.postDate()));
            }
            return websiteDTOs;
        } catch (RuntimeException e) {
            throw new RuntimeException("Error while searching for websites", e);
        }
    }
}
