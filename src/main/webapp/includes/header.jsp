<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="es" data-bs-theme="auto">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Music Vibe</title>

  <link rel="canonical" href="https://getbootstrap.com/docs/5.3/examples/sign-in/">

  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@docsearch/css@3">

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">

  <link rel="icon" type="image/png" href="icons/logo.png">

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
          integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
          crossorigin="anonymous"></script>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

  <link href="css/login.css" rel="stylesheet">

</head>

  <%
    HttpSession currentSession = request.getSession();

    String role = "anonymous";
    int id_user  ;
    if (currentSession.getAttribute("role") != null) {
      role = (String) currentSession.getAttribute("role").toString();
    }
    if (currentSession.getAttribute("id") != null) {
      id_user = (int) currentSession.getAttribute("id");
    }else {id_user=0;}
  %>

<body>

<header data-bs-theme="dark">
  <nav class="navbar navbar-expand-lg  bg-black">
    <div class="container-fluid">
      <a class="navbar-brand" href="index.jsp">
        <img src="icons/logo.png" alt="Logo" width="50" height="50" class="d-inline-block align-text-top">
      </a>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse d-flex justify-content-end" id="navbarNavDropdown">
        <ul class="navbar-nav">
          <li class="nav-item">
            <%
              if (role.equals("anonymous")) {
            %>
            <a class="nav-link" href="login.jsp">Iniciar Sesión</a>

            <li class="nav-item">
              <a class="nav-link" href="edit-user.jsp">Registrarse</a>
            </li>

            <%
            } else {
            %>

            <li class="nav-item">
              <a class="nav-link" href="view-playlists.jsp">Mis Playlist</a>
            </li>

            <li class="nav-item">
              <a class="nav-link" href="edit-user.jsp?id_user=<%= id_user %>">Modificar Usuario</a>
            </li>

            <a class="nav-link" href="logout">Cerrar Sesión</a>
            <%
              }
            %>
          </li>
        </ul>
      </div>
    </div>
  </nav>
</header>
