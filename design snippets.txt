
SMOOTH SCROLLING--------start------------------------------------------------------------------------------
html---
<body data-spy="scroll" data-target=".navbar" data-offset="120">
  <nav class="navbar navbar-expand navbar-light fixed-top bg-light">
    <a class="navbar-brand" href="#">Navbar</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav">
        <li class="nav-item active">
          <a class="nav-link" href="#div1">Div 1 </a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#div2">Div 2</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#div3">Div 3</a>
        </li>
      </ul>
    </div>
  </nav>
  <div id="div1">TEST 1</div>
  <div id="div2">TEST 2</div>
  <div id="div3">TEST 3</div>
</body>

css---
html {
  scroll-behavior: smooth;
}

#div1 {
  padding-top: 56px;
  height: 100vh;
  background-color: lightblue;
}

#div2 {
  padding-top: 56px;
  height: 100vh;
  background-color: blue;
}

#div3 {
  padding-top: 56px;
  height: 100vh;
  background-color: red;
}
SMOOTH SCROLLING--------end------------------------------------------------------------------------------
