package com.svalero.musicvibe.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class AlbumTracksArtist {
    private int idTrack;
    private String nameTrack;
    private int durationTrack;
    private String artistName;
    private String albumName;
    private String albumPicture;
    private String audioTrack;
}
