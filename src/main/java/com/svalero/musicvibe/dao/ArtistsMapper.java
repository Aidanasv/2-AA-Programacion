package com.svalero.musicvibe.dao;

import com.svalero.musicvibe.domain.Artist;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;

import java.sql.ResultSet;
import java.sql.SQLException;

public class ArtistsMapper implements RowMapper<Artist> {

    @Override
    public Artist map(ResultSet rs, StatementContext ctx) throws SQLException {
        return new Artist(rs.getInt("id_artist"),
                rs.getString("name"),
                rs.getString("picture"),
                rs.getString("genre"));
    }
}
