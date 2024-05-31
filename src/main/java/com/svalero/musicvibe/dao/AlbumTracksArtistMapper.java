package com.svalero.musicvibe.dao;

import com.svalero.musicvibe.domain.AlbumTracksArtist;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;

import java.sql.ResultSet;
import java.sql.SQLException;

public class AlbumTracksArtistMapper implements RowMapper<AlbumTracksArtist> {
    @Override
    public AlbumTracksArtist map(ResultSet rs, StatementContext ctx) throws SQLException {
        return new AlbumTracksArtist(rs.getInt("idTrack"),
                rs.getString("nameTrack"),
                rs.getInt("durationTrack"),
                rs.getString("artistName"),
                rs.getString("albumName"),
                rs.getString("albumPicture"),
                rs.getString("audioTrack"));
    }
}
