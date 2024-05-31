<%@ page import="com.svalero.musicvibe.domain.User" %>
<%@ page import="com.svalero.musicvibe.dao.Database" %>
<%@ page import="com.svalero.musicvibe.dao.UserDao" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@include file="includes/header.jsp" %>

<script type="text/javascript">
    $(document).ready(function () {
        $("#login-form").on("submit", function(event) {
            event.preventDefault();
            const formValue = $(this).serialize();
            $.ajax("sing-up", {
                type: "POST",
                data: formValue,
                statusCode: {
                    200: function(response) {
                        if (response === "ok") {
                            window.location.href = "/MusicVibe";
                        } else {
                            $("#result").html(response);
                        }
                    }
                }
            });
        });
    });
</script>

<main class="form-signin w-100 m-auto">
  <%
    User user = null;
    if (id_user!=0){
      Database.connect();
      user = Database.jdbi.withExtension(UserDao.class, dao -> dao.getUser(id_user));
    }
  %>

  <form id="login-form">
    <img class="mb-4" src="icons/logo.png" alt="" width="70" height="70">
    <%
      if (id_user == 0) {
    %>
    <h1 class="h3 mb-3 fw-normal">Registrarme</h1>
    <%
      }else {
    %>
    <h1 class="h3 mb-3 fw-normal">Modificar mi Usuario</h1>
    <% }%>

    <div class="form-floating mb-3">
      <input type="text" name="username" class="form-control" id="floatingInput" placeholder="Mi usuario"
        <% if (id_user != 0) { %> value="<%= user.getUsername() %>"<% } %>>
      <label for="floatingInput">Usuario</label>
    </div>

    <div class="form-floating mb-3">
      <input type="text" name="name" class="form-control" id="floatingInput1" placeholder="Nombre"
        <% if (id_user != 0) { %> value="<%= user.getName() %>"<% } %>>
      <label for="floatingInput1">Nombre</label>
    </div>

    <div class="form-floating mb-3">
      <input type="password" name="password" class="form-control" id="floatingPassword" placeholder="Mi contraseña">
      <label for="floatingPassword">Contraseña</label>
    </div>

    <div class="form-floating mb-3">
      <input type="password" name="password2" class="form-control" id="floatingPassword2" placeholder="Repetir contraseña">
      <label for="floatingPassword2">Repetir Contraseña</label>
    </div>

    <input type="hidden" name="id_user" value="<%= id_user %>"/>

    <button class="btn btn-success w-100 py-2" type="submit">
      <%
        if (id_user == 0) {
      %>
      Registrarme
      <%
      }else {
      %>
      Modificar mi Usuario
      <% }%>
    </button>
  </form>
  <br>
  <div id="result"></div>
</main>

<%@include file="includes/footer.jsp" %>