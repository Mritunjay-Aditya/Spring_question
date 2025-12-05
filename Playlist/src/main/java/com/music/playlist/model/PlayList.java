package com.music.playlist.model;

import jakarta.persistence.*;

import java.util.Date;

@Entity
@Table(name = "play_list")
public class PlayList {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "play_list_id")
    private Long id;
    @Column(name = "play_list_name")
    private String name;
    @Column(name = "created_date")
    private Date createdDate;
    @Column(name = "tracks_count")
    private Integer tracksCount;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public Integer getTracksCount() {
        return tracksCount;
    }

    public void setTracksCount(Integer tracksCount) {
        this.tracksCount = tracksCount;
    }
}
