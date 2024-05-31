package com.svalero.musicvibe.dao;

import com.svalero.musicvibe.domain.Playlist;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;

import java.sql.ResultSet;
import java.sql.SQLException;

public class PlaylistMapper implements RowMapper<Playlist> {

    @Override
    public Playlist map(ResultSet rs, StatementContext ctx) throws SQLException {
        return new Playlist(rs.getInt("id_playlist"),
                rs.getInt("id_user"),
                rs.getString("name"));
    }
}
