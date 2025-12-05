package com.music.streaming.platform.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDate;

@Entity
@Table(name = "track")
@Getter
@Setter
public class Track extends Audit {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "track_id")
    private Long id;
    @Column(name = "title")
    private String title;
    @Column(name = "album_name")
    private String albumName;
    @Column(name = "release_date")
    private LocalDate releaseDate;
    @Column(name = "duration")
    private String duration;
    @Column(name = "genre")
    private String genre;
    @Column(name = "description")
    private String description;
    @Column(name = "playCount")
    private Integer playCount;
    @Column(name = "file_url")
    private String fileUrl;
    @Column(name = "cover_image")
    private String coverImage;
    @ManyToOne
    @JoinColumn(name = "artist_id")
    private Artist artist;
}
