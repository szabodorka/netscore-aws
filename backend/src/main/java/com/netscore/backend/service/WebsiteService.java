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


    private String extractDomain(String inputUrl) {
        if (inputUrl == null || inputUrl.isBlank()) return null;
        String newUrl = inputUrl.trim();
        if (!newUrl.startsWith("http://") && !newUrl.startsWith("https://")) {
            newUrl = "http://" + newUrl;
        }
        try {
            java.net.URL url = new java.net.URL(newUrl);
            String host = url.getHost().toLowerCase();
            String[] urlParts = host.split("\\.");
            if (urlParts.length >= 2) {
                return urlParts[urlParts.length - 2] + "." + urlParts[urlParts.length - 1];
            }
            return host;
        } catch (Exception e) {
            return null;
        }
    }

    private String generateName(String domain) {
        if (domain == null || domain.isBlank()) return "Unknown";
        String base = domain.split("\\.")[0];
        if (base.isEmpty()) return "Unknown";
        return Character.toUpperCase(base.charAt(0)) + base.substring(1);
    }

    private String getLink(String domain) {
        if (domain == null || domain.isBlank()) return null;
        return "https://www." + domain;
    }

    public List<WebsiteDTO> getAllWebsites() {
        try {
            List<Website> all = websiteDAO.getAllWebsites();
            List<WebsiteDTO> dtos = new ArrayList<>();
            for (Website website : all) {
                dtos.add(new WebsiteDTO(
                    website.id(), website.domain(), website.name(), website.url(), website.description(), website.userId(), website.postDate()
                ));
            }
            return dtos;
        } catch (RuntimeException e) {
            throw new RuntimeException("Error while getting all websites", e);
        }
    }

    public WebsiteDTO getWebsiteById(int id) {
        try {
            Website website = websiteDAO.getWebsite(id);
            if (website == null) return null;
            return new WebsiteDTO(
                website.id(), website.domain(), website.name(), website.url(), website.description(), website.userId(), website.postDate()
            );
        } catch (RuntimeException e) {
            throw new RuntimeException("Error while getting website by ID", e);
        }
    }

    public int addNewWebsite(NewWebsiteDTO dto) {
        try {
            String domain = extractDomain(dto.url());
            if (domain == null) throw new RuntimeException("Invalid URL or domain");
            String name = generateName(domain);
            String url = getLink(domain);
            String description = dto.description();
            NewWebsite newWebsite = new NewWebsite(domain, name, url, description, dto.userId());
            return websiteDAO.createWebsite(newWebsite);
        } catch (RuntimeException e) {
            throw new RuntimeException("Error while adding new website", e);
        }
    }

    public List<WebsiteDTO> searchWebsitesBySearchTerm(String searchTerm) {
        try {
            List<Website> found = websiteDAO.getSearchedWebsites(searchTerm);
            List<WebsiteDTO> dtos = new ArrayList<>();
            for (Website website : found) {
                dtos.add(new WebsiteDTO(
                    website.id(), website.domain(), website.name(), website.url(), website.description(), website.userId(), website.postDate()
                ));
            }
            return dtos;
        } catch (RuntimeException e) {
            throw new RuntimeException("Error while searching for websites", e);
        }
    }

    public void deleteWebsiteById(int id) {
        try {
            websiteDAO.deleteWebsite(id);
        } catch (RuntimeException e) {
            throw new RuntimeException("Error while deleting website", e);
        }
    }

}
