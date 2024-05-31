package com.svalero.musicvibe.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.sql.Date;


@NoArgsConstructor
@AllArgsConstructor
@Data
public class Album {
    private int id_album;
    private int id_artist;
    private String name;
    private String picture;
    private Date release_date;

}
