package com.netscore.backend.controller;

import com.netscore.backend.controller.dto.website.WebsiteDTO;
import com.netscore.backend.controller.dto.website.NewWebsiteDTO;
import com.netscore.backend.service.WebsiteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("api/website")
public class WebsiteController {
    private final WebsiteService websiteService;

    @Autowired
    public WebsiteController(WebsiteService websiteService) {
        this.websiteService = websiteService;
    }

    @GetMapping("/all")
    public List<WebsiteDTO> getAllWebsites() {
        return websiteService.getAllWebsites();
    }

    @GetMapping("/{id}")
    public WebsiteDTO getWebsiteById(@PathVariable int id) {
        return websiteService.getWebsiteById(id);
    }

    @GetMapping("/search")
    public List<WebsiteDTO> searchWebsites(@RequestParam String searchTerm) {
        return websiteService.searchWebsitesBySearchTerm(searchTerm);
    }

    @PostMapping("/")
    @ResponseStatus(HttpStatus.CREATED)
    public int addNewWebsite(@RequestBody NewWebsiteDTO website) {
        return websiteService.addNewWebsite(website);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteWebsiteById(@PathVariable int id) {
        websiteService.deleteWebsiteById(id);
    }
}
