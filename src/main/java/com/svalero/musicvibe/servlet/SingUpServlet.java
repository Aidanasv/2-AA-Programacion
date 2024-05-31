package com.svalero.musicvibe.servlet;

import com.svalero.musicvibe.dao.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

import static com.svalero.musicvibe.util.ErrorUtils.sendError;
import static com.svalero.musicvibe.util.ErrorUtils.sendMessage;

@WebServlet("/sing-up")
@MultipartConfig
public class SingUpServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        try {
            int id =0;
            if (request.getParameter("id_user") != null){
                id = Integer.parseInt(request.getParameter("id_user"));
            }
            if (hasValidationErrors(request, response))
                return;

            String name = request.getParameter("name");
            String username = request.getParameter("username");
            String password="";
            if (request.getParameter("password") != null) {
                password = request.getParameter("password");
            }
            String role = "user";

            HttpSession currentSession = request.getSession();
            if (currentSession.getAttribute("role") != null) {
                if (currentSession.getAttribute("role").equals("admin")) {
                    if (!request.getParameter("role").isBlank()) {
                        role = request.getParameter("role");
                    }
                }
            }

            Database.connect();
            final String finalrole = role;
            final String finalpassword=password;
            if (id ==0) {
                int affectedRows = Database.jdbi.withExtension(UserDao.class,
                        dao -> dao.addUser(name, username, finalpassword, finalrole));
                sendMessage("Se ha registrado con exito", response);
            } else {
                final int finalid = id;
                int affectedRows = Database.jdbi.withExtension(UserDao.class,
                        dao -> dao.updateUser(name, username, finalpassword, finalid));
                sendMessage("Usuario modificado correctamente", response);

            }

        } catch (ClassNotFoundException cnfe) {
            cnfe.printStackTrace();
            sendError("Internal Server Error", response);
        } catch (SQLException sqle) {
            sqle.printStackTrace();
            sendError("Error conectando con la base de datos", response);
        }catch (Exception e) {
            e.printStackTrace();
            sendError("Error al ingresar el usuario", response);
        }
    }
    private boolean hasValidationErrors(HttpServletRequest request, HttpServletResponse response) throws IOException {
        boolean hasErrors = false;
        if (request.getParameter("name").isBlank()) {
            sendError("Nombre es un campo obligatorio", response);
            hasErrors = true;
        }

        if (request.getParameter("username").isBlank()) {
            sendError("Username es un campo obligatorio", response);
            hasErrors = true;
        }

        if (request.getParameter("password").isBlank()) {
            sendError("Contraseña es un campo obligatorio", response);
            hasErrors = true;
        }

        if (request.getParameter("password2").isBlank()) {
            sendError("Repita la contraseña introducida anteriormente", response);
            hasErrors = true;
        }

        if (!request.getParameter("password").equals(request.getParameter("password2"))) {
            sendError("Las contraseñas deben ser iguales", response);
            hasErrors = true;
        }
        return hasErrors;
    }
}