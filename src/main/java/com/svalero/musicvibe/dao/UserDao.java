package com.svalero.musicvibe.dao;

import com.svalero.musicvibe.domain.User;
import org.jdbi.v3.sqlobject.statement.SqlQuery;
import org.jdbi.v3.sqlobject.statement.SqlUpdate;
import org.jdbi.v3.sqlobject.statement.UseRowMapper;

import java.util.List;

public interface UserDao {
    @SqlQuery("SELECT * FROM users")
    @UseRowMapper(UserMapper.class)
    List<User> getAllUsers();

    @SqlQuery("SELECT * FROM users WHERE id_user = ?")
    @UseRowMapper(UserMapper.class)
    User getUser(int id_user);

    @SqlQuery("SELECT * FROM users WHERE username  = ? AND password = ?")
    @UseRowMapper(UserMapper.class)
    User getUser(String username, String password);

    @SqlUpdate("INSERT INTO users (name, username, password, role) VALUES (?,?,?,?)")
    int addUser(String name, String username, String password, String role);

    @SqlUpdate("UPDATE users SET name = ?, username = ?, password = ? WHERE id_user =  ?")
    int updateUser(String name, String username, String password, int id_user);

    @SqlUpdate("DELETE FROM users WHERE id_user = ?")
    int removeUser(int id_user);
}
