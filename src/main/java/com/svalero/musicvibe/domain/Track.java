package com.svalero.musicvibe.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Track {
    private int id_track;
    private int id_album;
    private String name;
    private int duration;
    private String audio;
}
