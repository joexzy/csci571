// var http = require('http');
var express = require('express');
var cors = require('cors');
var app = express();
var request = require('request');

app.use(cors());

app.get('/', (req, res) => res.send('AWS succeed!'));

app.get('/geoname',function(req, res) {
    var pos = req.query.pos;
    var geoUrl = 'http://api.geonames.org/postalCodeSearchJSON?postalcode_startsWith=' + pos + '&username=xu50368976&country=US&maxRows=5';
    request(geoUrl, function (error, response, body) {
        if(!error && response.statusCode == 200){
            return res.send(body);
        }
        else{
            return res.send("Geoname Error");
        }
    })
});

app.get('/ebayFinding',function(req, res) {
    var ebayID = "ZiyiXu-xrwwxzyj-PRD-d16e5579d-b3eebcc0";
    var keyword = req.query.keyword;
    //keyword = encodeURI(keyword);
    var category = req.query.category;
    category = decodeURI(category);
    var newCon = req.query.newCon;
    var used = req.query.used;
    var unspecified = req.query.unspecified;
    var localPick = req.query.localPick;
    var freeShip = req.query.freeShip;
    var distance = req.query.distance;
    var zipcode = req.query.zipcode;

    var url = "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsAdvanced&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=" + ebayID + "&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&paginationInput.entriesPerPage=50&keywords="
    + keyword;

    if(category != "All"){
        var cateId;
        if(category == "Art") {
            cateId = 550;
        }
        else if(category == "Baby") {
            cateId = 2984;
        }
        else if(category == "Books") {
            cateId = 267;
        }
        else if(category =="Clothing, Shoes & Accessories") {
            cateId = 11450;
        }
        else if(category == "Computers/Tablets & Networking") {
            cateId = 58058;
        }
        else if(category == "Health & Beauty") {
            cateId = 26395;
        }
        else if(category == "Music") {
            cateId = 11233;
        }
        else if(category == "Video Games & Consoles") {
            cateId = 1249;
        }
        url += "&categoryId=" + cateId;
    }

    url += "&buyerPostalCode=" + zipcode;

    url += "&itemFilter(0).name=FreeShippingOnly&itemFilter(0).value=" + freeShip + "&itemFilter(1).name=LocalPickupOnly&itemFilter(1).value=" + localPick + "&itemFilter(2).name=HideDuplicateItems&itemFilter(2).value=true";

    var i = 0;
    var j = false;
    var q = false;
    if(newCon == "true"){
        url += "&itemFilter(3).name=Condition&itemFilter(3).value(" + i + ")=New";
        i ++;
        j = true;
        q = true;
    }
    if(used == "true"){
        if(q == true) {
            url += "&itemFilter(3).value(" + i + ")=Used";
        }
        else{
            url +="&itemFilter(3).name=Condition&itemFilter(3).value(" + i + ")=Used";
        }
        i ++;
        j = true;
        q = true;
    }
    if(unspecified == "true"){
        if(q == true) {
            url += "&itemFilter(3).value(" + i + ")=Unspecified";
        }
        else{
            url += "&itemFilter(3).name=Condition&itemFilter(3).value(" + i + ")=Unspecified";
        }
        j = true;
    }

    if(j == true) {
        url += "&itemFilter(4).name=MaxDistance&itemFilter(4).value=" + distance;
    }
    else{
        url += "&itemFilter(3).name=MaxDistance&itemFilter(3).value=" + distance;
    }

    url += "&outputSelector(0)=SellerInfo&outputSelector(1)=StoreInfo";

    request(url, function (error, response, body) {
        if(!error && response.statusCode == 200){

            var  data = JSON.parse(body);


            var handle = [];

            if(typeof(data.findItemsAdvancedResponse) == "undefined"){
                return res.send(handle);
            }
            if(typeof(data.findItemsAdvancedResponse[0].searchResult) == "undefined"){
                return res.send(handle);
            }

            var count = data.findItemsAdvancedResponse[0].searchResult[0]["@count"];

            if(count == 0){
                return res.send(handle);
            }

            for(var i = 0; i < count; i++){
                //console.log(i+1);
                var search = data.findItemsAdvancedResponse[0].searchResult[0].item;
                var temp = {};
                temp.index = i + 1;

                if(typeof(search[i].galleryURL) != "undefined"){
                    temp.imgUrl = search[i].galleryURL[0];
                }
                else{
                    temp.imgUrl = "NA";
                }

                if(typeof(search[i].title) != "undefined"){
                    temp.title = search[i].title[0];
                    temp.itemId = search[i].itemId[0];

                    if(temp.title.length > 35){
                        temp.short = help(temp.title) + "...";
                    }
                    else{
                        temp.short = temp.title;
                    }
                }
                else{
                    temp.title = "NA";
                }

                function help(str){
                    if(str.length > 35){
                        var str2 = str;
                        str = str.substring(0,35);
                        if(str2.charAt(35) == " "){
                        }
                        else if(str2.charAt(34) == " "){
                            str = str.substring(0,34);
                        }
                        else{
                            for(var i = str.length - 1; i >= 0; i --){
                                if(str.charAt(i) == " "){
                                    str = str.substring(0,i);
                                    break;
                                }
                            }
                        }
                    }
                    return str;
                }

                if(typeof(search[i].sellingStatus) != "undefined"){
                    if(typeof(search[i].sellingStatus[0].currentPrice) != "undefined"){
                        temp.price = "$" + search[i].sellingStatus[0].currentPrice[0].__value__;
                        temp.priceNum = search[i].sellingStatus[0].currentPrice[0].__value__;

                    }
                    else{
                        temp.price = "NA";
                    }
                }
                else{
                    temp.price = "NA"
                }

                if(typeof(search[i].shippingInfo) != "undefined") {
                    if (typeof (search[i].shippingInfo[0].shippingServiceCost) != "undefined") {
                        var ship = search[i].shippingInfo[0].shippingServiceCost[0].__value__;
                        if (ship == "0.0") {
                            temp.shipping = "FREE SHIPPING";
                        }
                        else {
                            temp.shipping = "$" + ship;
                        }

                    }
                    else{
                        temp.shipping = "NA";
                    }
                }
                else{
                    temp.shipping = "NA";
                }

                if(typeof(search[i].postalCode) != "undefined"){
                    temp.zipcode = search[i].postalCode[0];
                }
                else{
                    temp.zipcode = "NA";
                }

                if(typeof(search[i].sellerInfo) != "undefined"){
                    if(typeof(search[i].sellerInfo[0].sellerUserName) != "undefined"){
                        temp.seller = search[i].sellerInfo[0].sellerUserName[0];
                    }
                    else{
                        temp.seller = "NA";
                    }
                }
                else{
                    temp.seller = "NA";
                }

                if(typeof(search[i].shippingInfo) != "undefined"){
                    temp.shippingInfo = search[i].shippingInfo;
                }

                if(typeof(search[i].returnsAccepted) != "undefined"){
                    temp.return = search[i].returnsAccepted[0];
                }

                if(typeof(search[i].condition) != "undefined"){
                    if(typeof(search[i].condition[0].conditionId) != "undefined"){
                        let condition = search[i].condition[0].conditionId
                        if(condition == "1000"){
                            temp.condition = "NEW";
                        }
                        else if(condition == "2000" || condition == "2500"){
                            temp.condition = "REFURBISHED";
                        }
                        else if(condition == "3000" || condition == "4000" || condition == "5000" || condition == "6000"){
                            temp.condition = "USED";
                        }
                        else{
                            temp.condition = "NA";
                        }
                    }
                    else{
                        temp.condition = "NA"
                    }
                }
                else{
                    temp.condition = "NA"
                }

                if(typeof(search[i].viewItemURL) != "undefined"){
                    temp.itemUrl = search[i].viewItemURL[0];
                }
                else{
                    temp.itemUrl = "NA";
                }


                //console.log(temp);
                handle.push(temp);


            }

            handle = JSON.stringify(handle);
            return res.send(handle);
        }
        else{
            return res.send("ebay finding api Error");
        }
    })
});

app.get('/detail',function(req, res) {
    var id = req.query.id;
    var appId = "ZiyiXu-xrwwxzyj-PRD-d16e5579d-b3eebcc0";
    var detailUrl = "http://open.api.ebay.com/shopping?callname=GetSingleItem&responseencoding=JSON&appid=" + appId + "&siteid=0&version=967&ItemID=" + id + "&IncludeSelector=Description,Details,ItemSpecifics";
    request(detailUrl, function (error, response, body) {
        if(!error && response.statusCode == 200){
            return res.send(body);
        }
        else{
            return res.send("Ebay Detail Error");
        }
    })
});

app.get('/info',function(req, res) {
    var id = req.query.id;
    var appId = "ZiyiXu-xrwwxzyj-PRD-d16e5579d-b3eebcc0";
    var detailUrl = "http://open.api.ebay.com/shopping?callname=GetSingleItem&responseencoding=JSON&appid=" + appId + "&siteid=0&version=967&ItemID=" + id + "&IncludeSelector=Description,Details,ItemSpecifics";
    request(detailUrl, function (error, response, body) {
        if(!error && response.statusCode == 200) {
            var data = JSON.parse(body);


            var handle = [];

            if (typeof (data.Item) == "undefined") {
                return res.send(handle);
            }

            var info = data.Item;
            var temp = {};

            if(typeof(info.ItemID) != "undefined"){
                temp.itemId = info.ItemID;
            }

            if(typeof (info.PictureURL) != "undefined"){
                temp.pictureURL = info.PictureURL;
            }

            if(typeof (info.Title) != "undefined"){
                temp.title = info.Title;
            }

            if(typeof(info.CurrentPrice) != "undefined"){
                if(typeof (info.CurrentPrice.Value) != "undefined"){
                    temp.price = "$" + info.CurrentPrice.Value;
                    temp.priceNum = info.CurrentPrice.Value;
                }
                else{
                    temp.price = "NA"
                }
            }
            else{
                temp.price = "NA"
            }

            if(typeof(info.ItemSpecifics) != "undefined"){
                if(typeof (info.ItemSpecifics.NameValueList) != "undefined"){
                    temp.description = info.ItemSpecifics.NameValueList;
                }
                else{
                    temp.description = [];
                }
            }
            else{
                temp.description = [];
            }

            handle.push(temp)
            handle = JSON.stringify(handle);
            return res.send(handle);
        }
        else{
            return res.send("Tabbar info Error");
        }
    })
});

app.get('/shipping',function(req, res) {
    var id = req.query.id;
    var ship = req.query.ship;
    var appId = "ZiyiXu-xrwwxzyj-PRD-d16e5579d-b3eebcc0";
    var detailUrl = "http://open.api.ebay.com/shopping?callname=GetSingleItem&responseencoding=JSON&appid=" + appId + "&siteid=0&version=967&ItemID=" + id + "&IncludeSelector=Description,Details,ItemSpecifics";
    request(detailUrl, function (error, response, body) {
        if(!error && response.statusCode == 200) {

            var data = JSON.parse(body);


            var handle = [];

            if (typeof (data.Item) == "undefined") {
                return res.send(handle);
            }

            var info = data.Item
            var temp = {};

            temp.seller = {};
            temp.shipping = {};
            temp.return = {};

            //seller
            if(typeof(info.Storefront) != "undefined"){
                if(typeof(info.Storefront.StoreName) != "undefined"){
                    temp.seller.storeName = info.Storefront.StoreName;
                }
                if(typeof(info.Storefront.StoreURL) != "undefined"){
                    temp.seller.storeUrl = info.Storefront.StoreURL;
                }
            }


            if(typeof(info.Seller) != "undefined"){
                if(typeof (info.Seller.FeedbackScore) != "undefined"){
                    temp.seller.feedbackScore = info.Seller.FeedbackScore;
                }
                if(typeof(info.Seller.PositiveFeedbackPercent) !="undefined"){
                    temp.seller.popularity = info.Seller.PositiveFeedbackPercent;
                }

                if(typeof(info.Seller.FeedbackRatingStar) != "undefined"){
                    let s = info.Seller.FeedbackScore
                    if(s < 10000){
                        temp.seller.starIcon = "star";
                        temp.seller.starColor = info.Seller.FeedbackRatingStar;
                        temp.seller.star = info.Seller.FeedbackRatingStar;
                    }
                    else if(s >= 10000){
                        temp.seller.starIcon = "starBorder"
                        let x = info.Seller.FeedbackRatingStar;
                        let count = x.length;
                        x = x.substring(0, count-8);
                        temp.seller.starColor = x;
                        temp.seller.star = info.Seller.FeedbackRatingStar;
                    }
                }
            }

            //ship
            if(ship != "NA"){
                temp.shipping.shipCost = ship;
            }

            if(typeof(info.GlobalShipping) != "undefined"){
                if(info.GlobalShipping == false) {
                    temp.shipping.global = "No";
                }
                else if(info.GlobalShipping == true){
                    temp.shipping.global = "Yes";
                }
            }

            if(typeof(info.HandlingTime) != "undefined"){
                let day = info.HandlingTime;
                if(day == 0 || day == 1){
                    temp.shipping.handle = day + " day";
                }
                else if(day > 1){
                    temp.shipping.handle = day + " days";
                }
            }

            //return
            if(typeof(info.ReturnPolicy) != "undefined"){
                if(typeof(info.ReturnPolicy.ReturnsAccepted) != "undefined"){
                    temp.return.policy = info.ReturnPolicy.ReturnsAccepted;
                }
                if(typeof(info.ReturnPolicy.Refund) != "undefined"){
                    temp.return.refund = info.ReturnPolicy.Refund;
                }
                if(typeof(info.ReturnPolicy.ReturnsWithin) != "undefined"){
                    temp.return.returnWithin = info.ReturnPolicy.ReturnsWithin;
                }
                if(typeof(info.ReturnPolicy.ShippingCostPaidBy) != "undefined"){
                    temp.return.paidBy = info.ReturnPolicy.ShippingCostPaidBy;
                }
            }


            handle.push(temp)

            handle = JSON.stringify(handle);
            return res.send(handle);
        }
        else{
            return res.send("Tabbar shipping Error");
        }
    })
});


app.get('/photos',function(req, res) {
    var title = req.query.title;
    var searchId = "004902709835258710998:ytzow1ukdl0";
    var appId = "AIzaSyAnJH9qiIsEejAEQKt4qX4Wtg0urAuZH4Q";
    var phUrl = "https://www.googleapis.com/customsearch/v1?q=" + title + "&cx=" + searchId + "&imgSize=huge&imgType=news&num=8&searchType=image&key=" + appId;
    request(phUrl, function (error, response, body) {
        if(!error && response.statusCode == 200){

            var data = JSON.parse(body);
            var handle = [];

            if(typeof(data.items) == "undefined"){
                return res.send(handle);
            }

            var count = data.items.length;

            for(var i = 0; i < count; i++){
                var temp = {};
                if(typeof(data.items[i].link) != "undefined"){
                    temp.link = data.items[i].link;
                    handle.push(temp);
                }
            }

            handle = JSON.stringify(handle);
            return res.send(handle);
        }
        else{
            return res.send("Google Search Enginee Error");
        }
    })
});

/**
app.get('/photo',function(req, res) {
    var title = req.query.title;
    var searchId = "004902709835258710998:ytzow1ukdl0";
    var appId = "AIzaSyAnJH9qiIsEejAEQKt4qX4Wtg0urAuZH4Q";
    var phUrl = "https://www.googleapis.com/customsearch/v1?q=" + title + "&cx=" + searchId + "&imgSize=huge&imgType=news&num=8&searchType=image&key=" + appId;
    request(phUrl, function (error, response, body) {
        if(!error && response.statusCode == 200){
            return res.send(body);
        }
        else{
            return res.send("Google Search Enginee Error");
        }
    })
});
 */

/**
app.get('/similar',function(req, res) {
    var id = req.query.id;
    var appId = "ZiyiXu-xrwwxzyj-PRD-d16e5579d-b3eebcc0";
    var simiUrl = "http://svcs.ebay.com/MerchandisingService?OPERATION-NAME=getSimilarItems&SERVICE-NAME=MerchandisingService&SERVICE-VERSION=1.1.0&CONSUMER-ID=" + appId + "&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&itemId=" + id + "&maxResults=20";
    request(simiUrl, function (error, response, body) {
        if(!error && response.statusCode == 200){
            return res.send(body);
        }
        else{
            return res.send("Similar Porducts Error");
        }
    })
});
 */

app.get('/similar',function(req, res) {
    var id = req.query.id;
    var appId = "ZiyiXu-xrwwxzyj-PRD-d16e5579d-b3eebcc0";
    var simiUrl = "http://svcs.ebay.com/MerchandisingService?OPERATION-NAME=getSimilarItems&SERVICE-NAME=MerchandisingService&SERVICE-VERSION=1.1.0&CONSUMER-ID=" + appId + "&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&itemId=" + id + "&maxResults=20";
    request(simiUrl, function (error, response, body) {
        if(!error && response.statusCode == 200){

            var data = JSON.parse(body);
            var handle = [];

            if (typeof (data.getSimilarItemsResponse) == "undefined") {
                return res.send(handle);
            }

            if(typeof (data.getSimilarItemsResponse.itemRecommendations) == "undefined"){
                return res.send(handle);
            }

            if(typeof (data.getSimilarItemsResponse.itemRecommendations.item) == "undefined"){
                return res.send(handle);
            }

            var simi = data.getSimilarItemsResponse.itemRecommendations.item
            var count = simi.length;

            if(count == 0){
                return res.send(handle);
            }
            var temp = {};

            for(var i = 0; i < count; i++){
                let item = simi[i];
                var temp = {};

                if(typeof(item.title) !="undefined"){
                    temp.name = item.title;
                }

                if(typeof(item.buyItNowPrice) != "undefined") {
                    if (typeof (item.buyItNowPrice.__value__) != "undefined") {
                        temp.price = item.buyItNowPrice.__value__;
                    }
                }

                if(typeof(item.shippingCost) != "undefined"){
                    if(typeof(item.shippingCost.__value__) != "undefined"){
                        temp.ship = item.shippingCost.__value__;
                    }
                }

                if(typeof(item.timeLeft) != "undefined"){
                    let day = getDay(item.timeLeft);
                    temp.left = day;
                }

                if(typeof(item.imageURL) != "undefined"){
                    temp.imgUrl = item.imageURL;
                }

                if(typeof(item.viewItemURL) != "undefined"){
                    temp.itemUrl = item.viewItemURL;
                }

                if(typeof(item.itemId) != "undefined"){
                    temp.itemId = item.itemId;
                }

                handle.push(temp)
            }


            handle = JSON.stringify(handle);
            return res.send(handle);
        }
        else{
            return res.send("Similar Porducts Error");
        }

        function getDay(str){
            let num = str.length;
            for(var i = 0; i < num; i ++){
                if(str.charAt(i) == "P" || str.charAt(i) == "p"){
                    str = str.substring(i+1);
                }
            }

            for(var i = 0; i < num; i ++){
                if(str.charAt(i) == "D" || str.charAt(i) == "d"){
                    str = str.substring(0, i);
                }
            }

            return str;
        }

    })
});

//app.listen(3000);
app.listen(3000, "localhost", () => console.log('Example app listening on port 3000!'));

//app.listen(8081);
