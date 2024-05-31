package com.svalero.musicvibe.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Artist {
    private int id;
    private String name;
    private String picture;
    private String genre;
}
