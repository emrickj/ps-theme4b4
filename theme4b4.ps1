[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[System.Xml.XmlDocument] $xd = new-object System.Xml.XmlDocument
$file = resolve-path("data\website.xml")
$xd.load($file)
$title = $xd.selectSingleNode("website/title").get_InnerText()
$pos=$title.IndexOf("> ");
if ($pos -ne -1) {$title=$title.Substring($pos+2)}
$pos=$title.IndexOf(" <");
if ($pos -ne -1) {$title=$title.Substring(0,$pos)}
$style = $xd.selectSingleNode("website/style").get_InnerText()
$pcnt = $xd.selectnodes("website/page[name!='']")
function ic_html([string]$pn) {
    if ($pn.indexOf(" ") -eq 1) {
        "<i class='fa'>"+$pn.Substring(0,1)+"</i>"+$pn.Substring(1)
    } else {$pn}
}
write-host "<!DOCTYPE html>"
write-host "<html>"
write-host "<head>"
write-host "<meta charset='utf-8'>"
write-host "<meta name='viewport' content='width=device-width,initial-scale=1'>"
write-host "<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">"
write-host "<link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css'>"
write-host "	<title>$title</title>"
write-host "<style>"
write-host "body {"
write-host "    position: relative;"
write-host "}"
write-host "ul.nav-pills {"
write-host "    top: 150px;"
write-host "    position: fixed;"
write-host "}`n"
write-host "@media (min-width: 576px) {"
write-host "	form label {text-align: right;}"
write-host "}"
write-host $style
write-host "</style>"
write-host "</head>"
$title = $xd.selectSingleNode("website/title").get_InnerText()
write-host "<body data-spy='scroll' data-target='#myScrollspy'>"
write-host "<div class='d-block d-md-none'>"
write-host "<nav class='navbar bg-dark navbar-dark fixed-top'>"
write-host "      <a class='navbar-brand' href='#'>$title</a>"
write-host "      <button type='button' class='navbar-toggler' data-toggle='collapse' data-target='#myNavbar'>"
write-host "		<span class='navbar-toggler-icon'></span>"
write-host "      </button>"
write-host "    <div class='collapse navbar-collapse' id='myNavbar'>"
write-host "      <ul class='navbar-nav'>"
$index = 1
foreach ($item in $pcnt) {
    $pname = $item.selectSingleNode("name").get_InnerText()
    write-host "           <li class='nav-item'><a class='nav-link' href='#p$index'>"
    ic_html $pname
    write-host "</a></li>"
    $index++
}
write-host "      </ul>"
write-host "    </div>"
write-host "</nav>"
write-host "</div>"
write-host "   <div class='container'>"
write-host "      <div class='row' id='p1'>"
write-host "         <div class='d-block d-md-none' style='padding-top: 50px;'></div>"
write-host "         <div class='col-md-3'>"
write-host "         </div>"
write-host "         <div class='col-md-9' style='padding: 20px'>"
write-host "            <b><h2 style='text-align: center;'>$title</h2></b>"
write-host "            <br>"
write-host "         </div>"
write-host "      </div>"
write-host "      <div class='row'>"
write-host "         <nav class='col-md-3 d-none d-md-block' id='myScrollspy'>"
write-host "           <ul class='nav nav-pills flex-column' role='menu'>"
$index = 1
foreach ($item in $pcnt) {
    $pname = $item.selectSingleNode("name").get_InnerText()
    write-host "           <li class='nav-item'><a class='nav-link' href='#p$index'>"
    ic_html $pname
    write-host "</a></li>"
    $index++
}
write-host "           </ul>"
write-host "         </nav>"
write-host "         <div class='col-md-9'>"
write-host "           <div class='card bg-light'>"
write-host "               <div class='card-body'>"
$index = 1
foreach ($item in $pcnt) {
    $lang = $item.getAttribute("language")
    $image = $item.selectSingleNode("image").get_InnerText()
    $cnt = $item.selectSingleNode("contents").get_InnerText()
    if ($index -ne 1) {
        write-host "<div id='p$index' lang='$lang'>"
        write-host "<div style='padding-top: 50px;'></div>"
    } else {write-host "<div lang='$lang'>"}
    if ($image.length -gt 4) {
        write-host "                <img class='img-fluid' style='display: block;margin: auto;' src='$image'>"
    }
    write-host $cnt
    $ptype = $item.getAttribute("type")
    if ($ptype -eq "form") {
	    write-host "			      <form class='form-horizontal' role='form' method='post'>"
	    write-host "					<div class='form-group row'>"
	    write-host "					   <label class='col-form-label col-sm-4' for='name'>Name:</label>"
	    write-host "					   <div class='col-sm-6'>"
	    write-host "						  <input type='text' class='form-control' name='name'>"
	    write-host "					   </div>"
	    write-host "					</div>"
	    write-host "					<div class='form-group row'>"
	    write-host "					   <label class='col-form-label col-sm-4' for='phone'>Contact Phone #:</label>"
	    write-host "					   <div class='col-sm-6'>"
	    write-host "						  <input type='text' class='form-control' name='phone'>"
	    write-host "					   </div>"
	    write-host "					</div>"
	    write-host "					<div class='form-group row'>"
	    write-host "					   <label class='col-form-label col-sm-4' for='email'>Email Address:</label>"
	    write-host "					   <div class='col-sm-6'>"
	    write-host "						  <input type='email' class='form-control' name='email'>"
	    write-host "					   </div>"
	    write-host "					</div>"
	    write-host "					<div class='form-group row'>"
	    write-host "					   <label class='col-form-label col-sm-4' for='message'>Message:</label>"
	    write-host "					   <div class='col-sm-6'>"
	    write-host "						  <textarea class='form-control' rows='5' name='message'></textarea>"
	    write-host "						  <br>"
	    write-host "						  <input type='submit' class='btn btn-info' value='Submit'>"
	    write-host "					   </div>"
	    write-host "					</div>"
	    write-host "				 </form>"
    }
    if ($ptype -eq "comments") {
        write-host "				 <div id='HCB_comment_box' style='color: inherit; background-color: inherit;'>"
        write-host "			     <a href='https://www.htmlcommentbox.com'>HTML Comment Box</a> is loading comments...</div>"
        write-host "				 <link rel='stylesheet' type='text/css' href='https://www.htmlcommentbox.com/static/skins/default/skin.css' />"
        write-host "				 <script type='text/javascript' language='javascript' id='hcb'> /*<!--*/ if(!window.hcb_user){hcb_user={  };} (function(){s=document.createElement('script');s.setAttribute('type','text/javascript');s.setAttribute('src', 'https://www.htmlcommentbox.com/jread?page='+escape((window.hcb_user && hcb_user.PAGE)||(''+window.location)).replace('+','%2B')+'&opts=470&num=10');if (typeof s!='undefined') document.getElementsByTagName('head')[0].appendChild(s);})(); /*-->*/ </script>"
    }
    write-host "</div>"
    $index++
}
write-host "               </div>"
write-host "				<div class='card-footer'>"
write-host "					<center>This website was created using <a href='https://www.gem-editor.com'>GEM</a>.</center>"
write-host "				</div>"
write-host "           </div>"
write-host "		   <br>"
write-host "         </div>"
write-host "      </div>"
write-host "   </div>"
write-host "<script src='https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js'></script>"
write-host "<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>"
write-host "<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>"
write-host "</body>"
write-host "</html>"
