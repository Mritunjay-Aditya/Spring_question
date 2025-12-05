package com.music.streaming.platform.dto;

import java.time.LocalDate;

public record TrackRequest(String title,
                           String albumName,
                           LocalDate releaseDate,
                           String duration,
                           String genre,
                           String description,
                           Integer playCount,
                           String fileUrl,
                           String coverImage) {
}
