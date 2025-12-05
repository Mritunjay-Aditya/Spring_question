package com.music.streaming.platform.dto;

public record ArtistRequest(String artistName,
                            String bio,
                            String genre,
                            String origin,
                            String formedYear,
                            String socialLink,
                            String image
) {
}
