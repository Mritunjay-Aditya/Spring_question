package com.music.streaming.platform.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Entity
@Table(name = "artist")
@Getter
@Setter
public class Artist extends Audit {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "artist_id")
    private Long id;
    @Column(name = "artist_name")
    private String artistName;
    @Column(name = "bio")
    private String bio;
    @Column(name = "genre")
    private String genre;
    @Column(name = "origin")
    private String origin;
    @Column(name = "formed_year")
    private String formedYear;
    @Column(name = "social_link")
    private String socialLink;
    @Column(name = "image")
    private String image;

    @OneToMany(mappedBy = "artist")
    private List<Track> tracksProduced;
}

