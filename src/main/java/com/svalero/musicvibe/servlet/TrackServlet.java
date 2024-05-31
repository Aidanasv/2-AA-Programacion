package com.svalero.musicvibe.servlet;

import com.svalero.musicvibe.dao.Database;
import com.svalero.musicvibe.dao.TrackDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.SQLException;
import java.util.UUID;

import static com.svalero.musicvibe.util.ErrorUtils.sendError;
import static com.svalero.musicvibe.util.ErrorUtils.sendMessage;

@WebServlet("/edit-track")
@MultipartConfig
public class TrackServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        HttpSession currentSession = request.getSession();
        if (currentSession.getAttribute("role") != null) {
            if (!currentSession.getAttribute("role").equals("admin")) {
                response.sendRedirect("/MusicVibe");
            }
        }

        try {
            if (hasValidationErrors(request, response))
                return;

            int id = 0;
            if (request.getParameter("id_track") != null) {
                id = Integer.parseInt(request.getParameter("id_track"));
            }

            int id_album = Integer.parseInt(request.getParameter("id_album"));
            String name = request.getParameter("name");
            int duration = Integer.parseInt(request.getParameter("duration"));
            Part audioPart = request.getPart("audio");

            String audioPath = request.getServletContext().getInitParameter("audio-path");
            String filename = null;

            filename = UUID.randomUUID() + ".mp3";
            InputStream fileStream = audioPart.getInputStream();
            Files.copy(fileStream, Path.of(audioPath + File.separator + filename));

            Database.connect();
            final String finalFilename = filename;
            if (id == 0) {
                Database.jdbi.withExtension(TrackDao.class,
                        dao -> dao.addTrack(id_album, name, duration, finalFilename));
                sendMessage("Canción registrada correctamente", response);
            } else {
                final int finalId = id;
                Database.jdbi.withExtension(TrackDao.class,
                        dao -> dao.updateTrack(name, duration, finalFilename, finalId));
                sendMessage("Canción modificada correctamente", response);
            }

        } catch (ClassNotFoundException cnfe) {
            cnfe.printStackTrace();
            sendError("Internal Server Error", response);
        } catch (SQLException sql) {
            sql.printStackTrace();
            sendError("Error conectando con la base de datos", response);
        } catch (Exception e) {
            e.printStackTrace();
            sendError("Error", response);
        }
    }

    private boolean hasValidationErrors(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        boolean hasErrors = false;

        if (request.getParameter("name").isBlank()) {
            sendError("El nombre es un campo obligatorio", response);
            hasErrors = true;
        }

        if (request.getPart("audio").getSize() == 0) {
            sendError("El audio es un campo obligatorio", response);
            hasErrors = true;
        }

        if (request.getParameter("duration").isBlank()) {
            sendError("La duración es un campo obligatorio", response);
            hasErrors = true;
        }
        return hasErrors;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        int id = Integer.parseInt(request.getParameter("id_track"));

        try {
            Database.connect();
            Database.jdbi.withExtension(TrackDao.class,
                    dao -> dao.removeTrack(id));
            response.getWriter().print("ok");
        } catch (ClassNotFoundException cnfe) {
            cnfe.printStackTrace();
            sendError("Error al eliminar la canción", response);
        } catch (SQLException sql) {
            sql.printStackTrace();
            sendError("Error al eliminar la canción", response);
        } catch (Exception e) {
            e.printStackTrace();
            sendError("Error al eliminar la canción", response);
        }
    }
}