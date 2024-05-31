package com.svalero.musicvibe.dao;

import com.svalero.musicvibe.domain.Album;
import org.jdbi.v3.core.statement.StatementContext;
import org.jdbi.v3.core.mapper.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class AlbumMapper implements RowMapper<Album> {

    @Override
    public Album map(ResultSet rs, StatementContext ctx) throws SQLException {
        return new Album(rs.getInt("id_album"),
                rs.getInt("id_artist"),
                rs.getString("name"),
                rs.getString("picture"),
                rs.getDate("release_date"));
    }
}
