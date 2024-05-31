<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@include file="includes/header.jsp" %>

<script type="text/javascript">
    $(document).ready(function () {
        $("#login-form").on("submit", function(event) {
            event.preventDefault();
            const formValue = $(this).serialize();
            $.ajax("login", {
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
  <form id="login-form">
    <img class="mb-4" src="icons/logo.png" alt="" width="70" height="70">
    <h1 class="h3 mb-3 fw-normal">Iniciar Sesión</h1>

    <div class="form-floating">
      <input type="text" name="username" class="form-control" id="floatingInput" placeholder="Mi usuario">
      <label for="floatingInput">Usuario</label>
    </div>
    <div class="form-floating">
      <input type="password" name="password" class="form-control" id="floatingPassword" placeholder="Mi contraseña">
      <label for="floatingPassword">Contraseña</label>
    </div>
    <button class="btn btn-success w-100 py-2" type="submit">Iniciar sesión</button>
  </form>
  <br>
  <div id="result"></div>
</main>

<%@include file="includes/footer.jsp" %>
