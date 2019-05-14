<?php
    $appId = "ZiyiXu-xrwwxzyj-PRD-d16e5579d-b3eebcc0";
    $keyword = isset($_POST['keyword']) ? $_POST['keyword'] : '';
    $category = isset($_POST['category']) ? $_POST['category'] : '';
    $new = isset($_POST['newCon']) ? $_POST['newCon'] : '';
    $used = isset($_POST['used']) ? $_POST['used'] : '';
    $unspecified = isset($_POST['unspecified']) ? $_POST['unspecified'] : '';
    $localPick = isset($_POST['localPick']) ? $_POST['localPick'] : '';
    $freeShip= isset($_POST['freeShip']) ? $_POST['freeShip'] : '';
    $enable= isset($_POST['enNearSer']) ? $_POST['enNearSer'] : '';
    if($enable == "true"){
        $distance= isset($_POST['distance']) ? $_POST['distance'] : '';
        $zip= isset($_POST['zip']) ? $_POST['zip'] : '';
    }
    $search= isset($_POST['search']) ? $_POST['search'] : "false";
    $id= isset($_POST['id']) ? $_POST['id'] : '';
    $detail= isset($_POST['detail']) ? $_POST['detail'] : "false";
    $similar= isset($_POST['similar']) ? $_POST['similar'] : "false";
    $simiId= isset($_POST['simiId']) ? $_POST['simiId'] : '';
    //echo $category;
    //$a = $keyword.$category.$new.$used.$unspecified.$localPick.$freeShip;
    //echo $a;
    if($search == "true"){
        $search = "false";
        $url = "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsAdvanced&SERVICE-VERSION=1.0.0&SECURITY-APPNAME="
            .$appId."&RESPONSE-DATA-FORMAT=JSON&RESTPAY-LOAD&paginationInput.entriesPerPage=20&keywords=".urlencode($keyword);

        if($category != "allCategory"){
            $cateId = 0;
            if($category == "art") {
                $cateId = 550;
            }
            elseif($category == "baby") {
                $cateId = 2984;
            }
            elseif($category == "books") {
                $cateId = 267;
            }
            elseif($category =="clothing") {
                $cateId = 11450;
            }
            elseif($category == "computer") {
                $cateId = 58058;
            }
            elseif($category == "health") {
                $cateId = 26395;
            }
             elseif($category == "music") {
                 $cateId = 11233;
             }
              elseif($category == "games") {
                  $cateId = 1249;
              }
            $url = $url."&categoryId=".$cateId;
        }

        if($enable == "true"){
            $url = $url."&buyerPostalCode=".$zip;
        }

        //if(($freeShip == "false") && ($localPick == "false")){
            //$url = $url."&itemFilter(0).name=FreeShippingOnly&itemFilter(0).value=true&itemFilter(1).name=LocalPickupOnly&itemFilter(1).value=true&itemFilter(2).name=HideDuplicateItems&itemFilter(2).value=true";
        //}
        //else{
            $url = $url."&itemFilter(0).name=FreeShippingOnly&itemFilter(0).value=".$freeShip."&itemFilter(1).name=LocalPickupOnly&itemFilter(1).value=".$localPick."&itemFilter(2).name=HideDuplicateItems&itemFilter(2).value=true";
        //}

        //if(($new == "false") && ($used == "false") && ($unspecified == "false")) {
            //$url = $url . "&itemFilter(3).name=Condition&itemFilter(3).value(0)=New&itemFilter(3).value(1)=Used&itemFilter(3).value(2)=Unspecified";
        //}
        //else{
        $i = 0;
        $j = false;
        $q = false;
        if($new == "true"){
            $url = $url."&itemFilter(3).name=Condition&itemFilter(3).value(".$i.")=New";
            $i = $i + 1;
            $j = true;
            $q = true;
        }
        if($used == "true"){
            if($q == true) {
                $url = $url."&itemFilter(3).value(" . $i . ")=Used";
            }
            else{
                $url = $url."&itemFilter(3).name=Condition&itemFilter(3).value(" . $i . ")=Used";
            }
            $i = $i + 1;
            $j = true;
            $q = true;
        }
        if($unspecified == "true"){
            if($q == true) {
                $url = $url . "&itemFilter(3).value(" . $i . ")=Unspecified";
            }
            else{
                $url = $url."&itemFilter(3).name=Condition&itemFilter(3).value(" . $i . ")=Unspecified";
            }
            $j = true;
        }

        if($enable == "true"){
            if($j == true) {
                $url = $url . "&itemFilter(4).name=MaxDistance&itemFilter(4).value=" . $distance;
            }
            else{
                $url = $url . "&itemFilter(3).name=MaxDistance&itemFilter(3).value=" . $distance;
            }
        }

        //echo $url;
        $getFile = file_get_contents($url);
        echo $getFile;

        //file_put_contents('result.json', $getFile);
        return;
    }

    if($detail == "true"){
        $detail = "false";
        $url = "http://open.api.ebay.com/shopping?callname=GetSingleItem&responseencoding=JSON&appid=".$appId."&siteid=0&version=967&ItemID=".$id."&IncludeSelector=Description,Details,ItemSpecifics";
        $getFile = file_get_contents($url);
        //echo $url;
        echo $getFile;
        return;
    }

    if($similar == "true"){
        $similar = "false";
        $url = "http://svcs.ebay.com/MerchandisingService?OPERATION-NAME=getSimilarItems&SERVICE-NAME=MerchandisingService&SERVICE-VERSION=1.1.0&CONSUMER-ID=".$appId
            ."&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&itemId=".$simiId."&maxResults=8";
        $getFile = file_get_contents($url);
        //echo $url;
        echo $getFile;
        return;
    }
    //$getFile = file_get_contents($url);
    //$jsonFile = json_decode($getFile);


?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Homework 6: PHP</title>
    <style>
        body{
            font-family: serif;
        }
        #myForm{
            height;500px;
            width:800px;
            margin:0 auto;
            border:2px;
            border-color: #C7C6C7;
            border-style: solid;
            font-family: serif;
            background-color: #FAF9FA;
        }
        #searchResult {
            border-collapse: collapse;
        }

        #searchResult td, #searchResult th{
            border-color: #C7C6C7;
            border-style: solid;
            border-width: 2px;

        }

        #detailTable {
            border-collapse: collapse;
        }

        #detailTable td, #detailTable th{
            border-color: #C7C6C7;
            border-style: solid;
            border-width: 2px;

        }

        a{
            text-decoration:none;
            color:black;
        }

        a:hover{
            color: grey;
            cursor: pointer;
        }

        a:active{
            color:black;
        }

        a:visited{
            color:black;
        }

        #simiTable a:hover{
            color: grey;
            cursor: pointer;
        }

        #searchResult a:hover{
            color: grey;
            cursor: pointer;
        }

        hr{
            width:750px;
        }

        h1{
            font-family: serif;
            text-align: center;
        }
        img{
            max-height: 100%;
            max-width: 100%
        }
        #bar{
            width: 60px;
        }
        #searchResult{
            margin: 20px auto;
        }
        .detail{

        }
        #detailTitle{
            text-align: center;
        }
        #detailTable{
            margin: 20px auto;
        }

        #ifrSell{
            text-align: center;
        }

        #similar{
            margin:0 auto;
            width:800px;
            height:320px;
            overflow: scroll;
            overflow-x: auto;
            overflow-y: hidden;

        }
        #simiTable{
            margin:0 auto;
            border-style:solid;
            border-width:2px;
            border-color: #C7C6C7;

        }

        #simiTable td, #simiTable th{
            min-width: 300px;
            text-align: center;
        }

        .arrow h3{
            color: #C7C6C7;
        }

        .arrow {
            text-align: center;
        }

        .arrow img{
            height: 40px;
            width: 100px;
        }

        #invalidZip{
            background-color: #FAF9FA;
            margin: 0 auto;
            width: 1000px;
        }

        .invalid{
            background-color: #FAF9FA;
            text-align: center;
            //margin: 0 auto;
            width: 1000px;
        }

        #noSeller{
            background-color: #DDDDDD;
            width: 1000px;
            margin:0 auto;
        }

        #noSimilar{
            text-align: center;
            margin:0 auto;
            width: 600px;
            border-style: solid;
            border-color: #E2E2E2;
            border-width: 1px;
        }
        #outTable{
            text-align: center;
            margin:0 auto;
            width: 620px;
            border-style: solid;
            border-color: #E2E2E2;
            border-width: 2px;
        }
        #noDeInfo{
            background-color: #C7C6C7;
        }
    </style>
</head>

<body>
    <div>
        <div>
            <form id='myForm' name="myForm" onsubmit="submitData(); serResult(); event.preventDefault();event.stopPropagation()" autocomplete="off">
                <h1><i>Product Search</i></h1>
                <hr>
                <div style="margin-left:130px">
                <label for="keyword"><b>Keyword</b></label>
                <input id="keyword" type="text" required>
                <br><br>
                <label for="category"><b>Category</b></label>
                <select id="category">
                    <option value="allCategory">All Categories</option>
                    <option value="art">Art</option>
                    <option value="baby">Baby</option>
                    <option value="books">Books</option>
                    <option value="clothing">Clothing, Shoes & Accessories</option>
                    <option value="computer">Computers/Tablets & Networking</option>
                    <option value="health">Health & Beauty</option>
                    <option value="music">Music</option>
                    <option value="games">Video Games & Consoles</option>
                </select>
                <br><br>
                <label for="condition"><b>Condition</b></label>
                <input type="checkbox" id="new" value="new" name="new">New
                <input type="checkbox" id="used" value="used" name="used">Used
                <input type="checkbox" id="unspecified" value="unspecified" name="unspecified">Unspecified
                <br><br>
                <label for="shipOpt"><b>Shipping Options</b></label>
                <input type="checkbox" id="localPick" value="localPick" name="localPick">Local Pickup
                <input type="checkbox" id="freeShip" value="freeShip" name="freeShip">Free Shipping
                <br><br>
                <input type="checkbox" id="enNearSer" name="enableNear" onclick="clickEnable()"><b>Enable NearBy Search&nbsp&nbsp&nbsp&nbsp</b>
                <input type="text" id="bar" placeholder="10" disabled>
                <p style="display:inline; color:grey" id="miles"><b>miles from</b></p>
                <div style="display:inline; position:absolute">
                <input type="radio" id="here" name="loc" value="here" checked disabled onclick="clickHere()">Here<br>
                <input type="radio" id="zip" name="loc" disabled onclick="clickZip()"> <input type="text" id="zipCode" placeholder="zip code" disabled required>
                </div>
                </div>
                <br><br>
                <div style="margin-left: 300px;margin-bottom: 10px">
                <input type="submit" id="submit" name="submit" value="Search" disabled">
                <input type="reset" id="clear" name="clear" value="Clear" onclick="clearAll()">
                </div>

            </form>
        </div>
    </div>

    <div id="searchResult">
    </div>

    <div id="details">
        <div id="detailTitle" style="display: none">
            <h1 style="font-weight: 900">Item Details</h1>
        </div>
        <div id="detailInfo" style="display: none"></div>
        <div style="display: none" id="sellerShow" class="arrow">
            <h3>click to show seller message</h3>
            <img src="http://csci571.com/hw/hw6/images/arrow_down.png" onclick="sellerShow()">
        </div>
        <div style="display: none" id="sellerHide" class="arrow">
            <h3>click to hide seller message</h3>
            <img src="http://csci571.com/hw/hw6/images/arrow_up.png" onclick="sellerHide()">
        </div>
        <div id="seller" style="display: none"></div>
        <div style="display: none" id="similarShow" class="arrow">
            <h3>click to show similar items</h3>
            <img src="http://csci571.com/hw/hw6/images/arrow_down.png" onclick="similarShow()">
        </div>
        <div style="display: none" id="similarHide" class="arrow">
            <h3>click to hide similar items</h3>
            <img src="http://csci571.com/hw/hw6/images/arrow_up.png" onclick="similarHide()">
        </div>
        <div id="similar" style="display: none"></div>
    </div>
</body>

<script type="text/javascript">

    var xmlhttp = new XMLHttpRequest();
    xmlhttp.open("GET", "http://ip-api.com/json", false);
    xmlhttp.send();
    if(xmlhttp.readyState == 4 ){
        if(xmlhttp.status == 200){
            var loc = JSON.parse(xmlhttp.responseText);
            var hereZip = loc.zip;
            //console.log(loc);
            //console.log(loc.zip);
            document.getElementById("submit").disabled = false;
        }
    }

    function clickEnable() {
        if (document.getElementById("enNearSer").checked === true) {
            document.getElementById("bar").disabled = false;
            document.getElementById("here").disabled = false;
            document.getElementById("zip").disabled = false;
            //document.getElementById("zipCode").disabled = false;
            document.getElementById("miles").style.color = "black";
        }
        else {
            document.getElementById("bar").disabled = true;
            document.getElementById("here").disabled = true;
            document.getElementById("zip").disabled = true;
            document.getElementById("zipCode").disabled = true;
            document.getElementById("miles").style.color = "grey";
        }
    }

    function clickHere() {
        document.getElementById("zipCode").disabled = true;
    }

    function clickZip() {
        document.getElementById("zipCode").disabled = false;
    }

    function clearAll() {
        /**
        document.getElementById("keyword").value ="";
        document.getElementById("category")[0].selected = true;
        document.getElementById("new").checked = false;
        document.getElementById("used").checked = false;
        document.getElementById("unspecified").checked = false;
        document.getElementById("localPick").checked = false;
        document.getElementById("freeShip").checked = false;
        document.getElementById("enNearSer").checked = false;
         */
        document.getElementById("bar").disabled = true;
        //document.getElementById("bar").value = "";
        //document.getElementById("miles").style.color = "grey";
        document.getElementById("here").checked = true;
        document.getElementById("here").disabled = true;
        document.getElementById("zip").checked = false;
        document.getElementById("zip").disabled = true;
        document.getElementById("zipCode").checked = false;
        document.getElementById("zipCode").disabled = true;
        //document.getElementById("zipCode").value = "";
        document.getElementById("searchResult").style.display = "none";
        document.getElementById("details").style.display = "none";
    }
    var data = "";
    function submitData(){
        var keyword = document.getElementById("keyword").value;
        var category = document.getElementById("category").value;
        var newCon = document.getElementById("new").checked;
        var used = document.getElementById("used").checked;
        var unspecified = document.getElementById("unspecified").checked;
        var localPick = document.getElementById("localPick").checked;
        var freeShip = document.getElementById("freeShip").checked;
        var enNearSer = document.getElementById("enNearSer").checked;
        var search = true;

        data = "keyword=" + keyword + "&" + "category=" + category + "&"
        + "newCon=" + newCon + "&" + "used=" + used + "&" + "unspecified=" + unspecified + "&"
        + "localPick=" + localPick + "&" + "freeShip=" + freeShip + "&" + "enNearSer=" + enNearSer;

        if(document.getElementById("enNearSer").checked){
            var distance;
            if(document.getElementById("bar").value === ""){
                distance = 10;
            }
            else{
                distance = document.getElementById("bar").value;
            }
            data += "&" + "distance=" + distance;
        }

        var zip;
        if(document.getElementById("here").checked){
            zip = hereZip;
        }
        if(document.getElementById("zip").checked){
            zip = document.getElementById("zipCode").value;
        }

        data += "&" + "zip=" + zip;
        data += "&" + "search=" + search;

        //console.log(data);
    }

    function serResult(){
        var searchText = "";
        var xhttp = new XMLHttpRequest();
        var self = "<?php echo $_SERVER["PHP_SELF"];?>";
        xhttp.overrideMimeType("application/json");
        xhttp.open("POST", self, false);
        xhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=utf-8");
        xhttp.send(data);

        if(xhttp.readyState == 4){
            if(xhttp.status == 200){
                //console.log(xhttp.responseText);
                //console.log(JSON.parse(xhttp.responseText));
                var json = JSON.parse(xhttp.responseText);
            }
        }
        //console.log(xhttp.responseText);
        //console.log(json.findItemsAdvancedResponse["0"].searchResult["0"]["@count"]);

        document.getElementById("searchResult").style.display = "none";
        document.getElementById("details").style.display = "none";

        if(document.getElementById("enNearSer").checked == true && document.getElementById("zip").checked == true){
             var zipCode = document.getElementById("zipCode").value;
             var reg = /^[0-9]{5}$/;
             var test = reg.test(zipCode);
             if(test == false || typeof(json.findItemsAdvancedResponse[0].searchResult) == "undefined"){
                 //alert("invalid zipcode");
                 searchText += "<table id='invalidZip'><tr><th>Zipcode is invalid</th></tr></table>";
                 document.getElementById("searchResult").innerHTML = searchText;
                 document.getElementById("searchResult").style.display = "block";
                 return;
             }
        }

        if(json.findItemsAdvancedResponse[0].searchResult[0]["@count"] !== "0"){
            var count =  parseInt(json.findItemsAdvancedResponse[0].searchResult[0]["@count"]);
            //console.log(count);
            //console.log(json.findItemsAdvancedResponse[0].searchResult[0].item[0].title.length);
            searchText += "<table id='searchResult'><tr><th>Index</th><th>Photo</th><th>Name</th><th>Price</th><th>Zip code</th><th>Condition</th><th>Shipping Option</th></tr>";

            for(var i = 0; i < count; i++){
                searchText += "<tr><td>" + (i+1) + "</td>";

                if(typeof(json.findItemsAdvancedResponse[0].searchResult[0].item[i].galleryURL) != "undefined") {
                    var imgUrl = json.findItemsAdvancedResponse[0].searchResult[0].item[i].galleryURL[0];
                    searchText += "<td><img alt='picture' src=" + imgUrl + "></td>";
                }
                else{
                    searchText += "<td>N/A</td>";
                }

                //console.log(json.findItemsAdvancedResponse[0].searchResult[0].item[i].itemId[0]);
                //console.log(json.findItemsAdvancedResponse[0].searchResult[0].item[].title.length);
                if(typeof(json.findItemsAdvancedResponse[0].searchResult[0].item[i].title) != "undefined") {
                    var itemId = json.findItemsAdvancedResponse[0].searchResult[0].item[i].itemId[0];
                    var name = json.findItemsAdvancedResponse[0].searchResult[0].item[i].title[0];
                    searchText += "<td><a href='#myForm' onclick='getDetail(" + itemId + ")' class='detail'>" + name + "</a></td>";
                }
                else{
                    searchText += "<td>N/A</td>";
                }

                if(typeof(json.findItemsAdvancedResponse[0].searchResult[0].item[i].sellingStatus) != "undefined"){
                    if(typeof(json.findItemsAdvancedResponse[0].searchResult[0].item[i].sellingStatus[0].currentPrice) != "undefined"){
                        var price = json.findItemsAdvancedResponse[0].searchResult[0].item[i].sellingStatus[0].currentPrice[0].__value__;
                        searchText += "<td>$" + price + "</td>";
                    }
                    else{
                        searchText += "<td>N/A</td>";
                     }
                 }
                else{
                    searchText += "<td>N/A</td>";
                }

                //console.log(typeof(json.findItemsAdvancedResponse[0].searchResult[0].item[i].postalCode));
                if(typeof(json.findItemsAdvancedResponse[0].searchResult[0].item[i].postalCode) != "undefined"){
                    //console.log(typeof (json.findItemsAdvancedResponse[0].searchResult[0].item[i].postalCode));
                    //var zipCode = "10000";
                    var zipCode = json.findItemsAdvancedResponse[0].searchResult[0].item[i].postalCode[0];
                    searchText += "<td>" + zipCode + "</td>";
                }
                else{
                    searchText += "<td>N/A</td>";
                }



                if(typeof(json.findItemsAdvancedResponse[0].searchResult[0].item[i].condition) != "undefined"){
                    if(typeof(json.findItemsAdvancedResponse[0].searchResult[0].item[i].condition[0].conditionDisplayName) != "undefined") {
                        var condition = json.findItemsAdvancedResponse[0].searchResult[0].item[i].condition[0].conditionDisplayName[0];
                        searchText += "<td>" + condition + "</td>";
                    }
                    else{
                        searchText += "<td>N/A</td>";
                    }
                }
                else{
                    searchText += "<td>N/A</td>";
                }

                if(typeof(json.findItemsAdvancedResponse[0].searchResult[0].item[i].shippingInfo) != "undefined") {
                    if (typeof (json.findItemsAdvancedResponse[0].searchResult[0].item[i].shippingInfo[0].shippingServiceCost) != "undefined") {
                        var ship = json.findItemsAdvancedResponse[0].searchResult[0].item[i].shippingInfo[0].shippingServiceCost[0].__value__;
                        if (ship == "0.0") {
                            searchText += "<td>Free Shipping</td>";
                        } else {
                            searchText += "<td>$" + ship + "</td>";
                        }

                    }
                    else{
                        searchText += "<td>N/A</td>";
                    }
                }
                else{
                    searchText += "<td>N/A</td>";
                }


                searchText += "</tr>";

            }
            searchText += "</table>";

        }
        else{
            searchText += "<table id='searchResult' class='invalid'><tr><td><b>No Records has been found</b></td></tr></table>";
        }

        document.getElementById("searchResult").innerHTML = searchText;
        document.getElementById("searchResult").style.display = "block";
    }

    function getDetail(itemId){
        document.getElementById("searchResult").style.display = "none";
        document.getElementById("detailTitle").style.display = "block";

        var input = "";
        var id = itemId;
        //console.log(id);
        input = "id=" + id + "&" + "detail=" + "true";
        var xhr = new XMLHttpRequest();
        var self = "<?php echo $_SERVER["PHP_SELF"];?>";
        xhr.overrideMimeType("application/json");
        xhr.open("POST", self, false);
        xhr.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=utf-8");
        xhr.send(input);

        if(xhr.readyState == 4){
            if(xhr.status == 200){
                //console.log(xhr.responseText);
                var json = JSON.parse(xhr.responseText);
                //console.log(json);
            }
        }
        //console.log(json.Item.PictureURL);
        //below is the item details
        var detailInfo = "";

        if(typeof(json.Item) == "undefined"){
            detailInfo += "<table id='noDetail'><tr><th>No Item Details Got</th></tr></table>";
            alert("This item's detailed information cannot be found.");
            return;
        }

        detailInfo += "<table id='detailTable'><tr><th>Photo</th>";
        detailInfo += "<td><div style='height: 400px;width:600px'><img alt='detail picture' src='" + json.Item.PictureURL[0] + "'></div></td></tr>";



        detailInfo += "<tr><th>Title</th>";
        if(json.Item.hasOwnProperty("Title")) {
            detailInfo += "<td>" + json.Item.Title + "</td></tr>";
        }
        else{
            detailInfo += "<td>N/A</td></tr>";
        }
        //detailInfo += "<td>" + json.Item.Title+"</td></tr>";

        detailInfo += "<tr><th>SubTitle</th>";
        if(json.Item.hasOwnProperty("Subtitle")) {
            detailInfo += "<td>" + json.Item.Subtitle + "</td></tr>";
        }
        else{
            detailInfo += "<td>N/A</td></tr>";
        }

        detailInfo += "<tr><th>Price</th>";
        if(json.Item.hasOwnProperty("CurrentPrice")) {
            detailInfo += "<td>" + json.Item.CurrentPrice.Value + " " + json.Item.CurrentPrice.CurrencyID + "</td></tr>";
        }
        else{
            detailInfo += "<td>N/A</td></tr>";
        }
        //detailInfo += "<td>" + json.Item.CurrentPrice.Value + " " + json.Item.CurrentPrice.CurrencyID + "</td></tr>";

        detailInfo += "<tr><th>Location</th>";
        if(json.Item.hasOwnProperty("Location")) {
            detailInfo += "<td>" + json.Item.Location;
            if(json.Item.hasOwnProperty("PostalCode")){
                detailInfo += ", " + json.Item.PostalCode + "</td></tr>";
            }
            else{
                detailInfo += "</td></tr>"
            }
        }
        else{
            detailInfo += "<td>N/A</td></tr>";
        }

        detailInfo += "<tr><th>Seller</th>";
        if(json.Item.hasOwnProperty("Seller")) {
            detailInfo += "<td>" + json.Item.Seller.UserID + "</td></tr>";
        }
        else{
            detailInfo += "<td>N/A</td></tr>";
        }
        //detailInfo += "<td>" + json.Item.Seller.UserID + "</td></tr>";

        detailInfo += "<tr><th>Return Policy(US)</th>";
        if(json.Item.hasOwnProperty("ReturnPolicy")) {
            detailInfo += "<td>" + json.Item.ReturnPolicy.ReturnsAccepted;
            if(json.Item.ReturnPolicy.hasOwnProperty("ReturnsWithin")){
                detailInfo += " within " + json.Item.ReturnPolicy.ReturnsWithin + "</td></tr>";
            }
            else{
                detailInfo += "</td></tr>";
            }
        }
        else{
            detailInfo += "<td>N/A</td></tr>";
        }
        //detailInfo += "<td>" + json.Item.ReturnPolicy.ReturnsAccepted + "</td></tr>";
        if(typeof(json.Item.ItemSpecifics) != "undefined") {
            var count = json.Item.ItemSpecifics.NameValueList.length;
            for (var i = 0; i < count; i++) {
                detailInfo += "<tr><th>" + json.Item.ItemSpecifics.NameValueList[i].Name + "</th>";
                detailInfo += "<td>" + json.Item.ItemSpecifics.NameValueList[i].Value[0] + "</td></tr>";
            }
        }

        else{
            detailInfo += "<tr><th>No Detail Info from Seller</th><th id='noDeInfo'></th></tr>";
        }

        detailInfo += "</table>"

        document.getElementById("details").style.display = "block";

        document.getElementById("detailInfo").style.display = "block";
        document.getElementById("detailInfo").innerHTML = detailInfo;

        document.getElementById("sellerShow").style.display = "block";
        document.getElementById("similarShow").style.display = "block";
        similarHide();
        sellerHide();
        //document.getElementById("sellerHide").style.display = "none";
        //document.getElementById("similarHide").style.display = "none";



        //below is the seller message
        //console.log(json.Item.Description);

        /**
         use iframe srcdoc, but someone doesn't work
        var seller = "";
        document.getElementById("seller").style.display = "block";
        if(json.Item.hasOwnProperty("Description")){
            var des = json.Item.Description;
            if(des != "") {
                seller += "<div id='ifrSell'><iframe id='myIframe' scrolling='no' srcdoc='" + des + "' onload='ifrLoad()'><iframe></div>";
            }
            else{
                seller += "<div id='ifrSell'><table id='iframeTable'><tr><th>No Seller Message found.</th></tr></table></div>";
            }

        }
        else{
            seller += "<div id='ifrSell'><table id='iframeTable'><tr><th>No Seller Message found.</th></tr></table></div>";
        }

        document.getElementById("seller").innerHTML = seller;
         */

        /**
         *below I use blob in html5
         */
        var seller = "";
        //document.getElementById("seller").style.display = "block";
        //document.getElementById("seller").style.display = "none";
        if(json.Item.hasOwnProperty("Description")){
            var des = json.Item.Description;
            //if(des =="55555"){   //to test no seller message
            if(des != "") {
                var blob = new Blob ([des], {"type":"text/html"});
                var blobURL = URL.createObjectURL(blob);
                seller += "<div id='ifrSell'><iframe id='myIframe' src='" + blobURL +"' onload='ifrLoad()' frameborder='no'><iframe></div>";
            }
            else{
                seller += "<div><table id='noSeller'><tr><th>No Seller Message found.</th></tr></table></div>";
            }

        }
        else{
            seller += "<div><table id='noSeller'><tr><th>No Seller Message found.</th></tr></table></div>";
        }
        document.getElementById("seller").innerHTML = seller;



        //below is similar items
        //document.getElementById("similar").style.display = "block";
        var similar = "";

        var sim = "similar=true" + "&" + "simiId=" + id;
        var xml = new XMLHttpRequest();
        xml.overrideMimeType("application/json");
        xml.open("POST", self, false);
        xml.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=utf-8");
        xml.send(sim);

        if(xml.readyState == 4){
            if(xml.status == 200){
                //console.log(xml.responseText);
                var simiJson = JSON.parse(xml.responseText);
                //console.log(simiJson);
            }
        }

        if(typeof(simiJson.getSimilarItemsResponse.itemRecommendations.item) == "undefined" || simiJson.getSimilarItemsResponse.itemRecommendations.item.length == 0){
            similar += "<table id='outTable'><tr><th><table id='noSimilar'><tr><th>No Similar Item found.</th></tr></table></th></tr></table>";
            document.getElementById("similar").innerHTML = similar;
            return;

        }

        similar += "<table id='simiTable'><tr>";
        var num = simiJson.getSimilarItemsResponse.itemRecommendations.item.length;
        //console.log(num);
        for(var i = 0; i < num; i++){
            var simiID = simiJson.getSimilarItemsResponse.itemRecommendations.item[i].itemId;
            var simiImg = simiJson.getSimilarItemsResponse.itemRecommendations.item[i].imageURL;
            similar += "<td><img alt='similar picture'src='" + simiImg + "'>";
            //similar += "<br><a href='javascript:getDetail(" + simiID + ")'><p>" + simiJson.getSimilarItemsResponse.itemRecommendations.item[i].title + "</a></p>";
            similar += "<br><a onclick='getDetail(" + simiID + ")' href='#myForm'><p>" + simiJson.getSimilarItemsResponse.itemRecommendations.item[i].title + "</a></p>";
            similar += "</td>";
        }

        similar += "</tr><tr>";

        for(var i = 0; i < num; i++){
            similar += "<th>$" + simiJson.getSimilarItemsResponse.itemRecommendations.item[i].buyItNowPrice.__value__ + "</th>";
        }

        similar += "</tr></table>";

        document.getElementById("similar").innerHTML = similar;
    }

    function ifrLoad(){
        document.getElementById("seller").style.display = "block";
        ifrLoad2();
    }

    function ifrLoad2(){
        var ifr = document.getElementById("myIframe");
        if(ifr){
            ifr.height = "0px";
            ifr.style.overflow = "hidden";
            ifr.height = ifr.contentDocument.documentElement.scrollHeight + "px";
        }
        ifr.width = "80%";
        ifrLoad3();
    }

    function ifrLoad3(){
        var ifr = document.getElementById("myIframe");
        if(ifr){
            ifr.height = "0px";
            ifr.style.overflow = "hidden";
            ifr.height = ifr.contentDocument.documentElement.scrollHeight + "px";

        }
        ifr.width = "80%";
        ifrLoad4();
    }

    function ifrLoad4(){
        document.getElementById("seller").style.display = "none";
    }

    function sellerShow(){
        document.getElementById("sellerShow").style.display = "none";
        document.getElementById("sellerHide").style.display = "block";
        document.getElementById("seller").style.display = "block";
        if(document.getElementById("similar").style.display == "block") {
            document.getElementById("similar").style.display = "none";
            document.getElementById("similarShow").style.display = "block";
            document.getElementById("similarHide").style.display = "none";
        }
    }

    function sellerHide() {
        document.getElementById("sellerShow").style.display = "block";
        document.getElementById("sellerHide").style.display = "none";
        document.getElementById("seller").style.display = "none";
    }

    function similarShow() {
        document.getElementById("similarShow").style.display = "none";
        document.getElementById("similarHide").style.display = "block";
        document.getElementById("similar").style.display = "block";
        if(document.getElementById("seller").style.display == "block") {
            document.getElementById("seller").style.display = "none";
            document.getElementById("sellerShow").style.display = "block";
            document.getElementById("sellerHide").style.display = "none";
        }
    }

    function similarHide(){
        document.getElementById("similarShow").style.display = "block";
        document.getElementById("similarHide").style.display = "none";
        document.getElementById("similar").style.display = "none";
    }

</script>
</html>
