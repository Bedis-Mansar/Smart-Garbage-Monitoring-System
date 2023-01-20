window.randomScalingFactor = function () {
    return (Math.random() > 0.5 ? 1.0 : -1.0) * Math.round(Math.random() * 100);
};



$(document).ready(function () {
    $.ajax({
        url: 'https://smartgarbagecot.me/api/profile/',
        type: 'GET',
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': Authorizationheader
        },
        success: function (data) {
            console.log('Load was performed.');
            document.getElementById("allusers").innerHTML = data.length
            var body = document.getElementById('tableuser');

            var tbl = document.createElement('table');
            tbl.setAttribute("id", 'mytable');
            let thead = document.createElement('thead');
            tbl.append(thead)
            let row_1 = document.createElement('tr');
            let heading_0 = document.createElement('th');
            heading_0.innerHTML = "Index";
            let heading_1 = document.createElement('th');
            heading_1.innerHTML = "Mail";
            let heading_2 = document.createElement('th');
            heading_2.innerHTML = "Name";
            let heading_3 = document.createElement('th');
            heading_3.innerHTML = "Role";
            row_1.appendChild(heading_0);
            row_1.appendChild(heading_1);
            row_1.appendChild(heading_2);
            row_1.appendChild(heading_3);

            thead.appendChild(row_1);

            var tbdy = document.createElement('tbody');
            for (var i = 0; i < 5; i++) {
                var tr = document.createElement('tr');
                var role;
                if (data[i].permissionLevel == 1) {
                    role = "Surfer"

                } else {
                    role = "Admin"
                }
                var block = [i + 1, data[i].mail, data[i].fullname, role]
                for (var j = 0; j < 4; j++) {

                    var td = document.createElement('td');
                    td.innerHTML = block[j]
                    tr.appendChild(td)

                }
                tbdy.appendChild(tr);
            }
            tbl.appendChild(tbdy);
            body.appendChild(tbl)
            var division = Math.floor(data.length / 5) + 1
            divisionstring = division.toString();
            var total = data.length.toString();
            document.getElementById("numentries").innerHTML = "Showing 1 to " + divisionstring + " of " + total + " entries"
            var paginationNumbers = document.getElementById("pagination");
            for (var index = 0; index < division; index++) {
                var pageNumber = document.createElement("li");
                pageNumber.className = "pagination-number";
                pageNumber.innerHTML = index + 1;
                pageNumber.setAttribute("page-index", index + 1);
                pageNumber.setAttribute("id", index + 1);
                pageNumber.addEventListener('click', function handleClick(event) {
                    var tbl = document.getElementById("mytable")
                    for (var j = tbl.rows.length - 1; j > 0; j--) {
                        document.getElementById("mytable").deleteRow(j);
                    }
                    var buttonindex = event.srcElement.id
                    for (var i = (buttonindex - 1) * 5; i < 5 * buttonindex; i++) {
                        if (i == data.length) {
                            break
                        } else {
                            var tr = document.createElement('tr');
                            var role;
                            if (data[i].permissionLevel == 1) {
                                role = "Surfer"

                            } else {
                                role = "Admin"
                            }
                            var block = [i + 1, data[i].mail, data[i].fullname, role]
                            for (var j = 0; j < 4; j++) {

                                var td = document.createElement('td');
                                td.innerHTML = block[j]
                                tr.appendChild(td)

                            }
                            tbdy.appendChild(tr);
                        }
                        tbl.appendChild(tbdy);
                        body.appendChild(tbl)
                        var division = Math.floor(data.length / 5) + 1
                        divisionstring = division.toString();
                        var total = data.length.toString();
                        document.getElementById("numentries").innerHTML = "Showing " + buttonindex + " to " + divisionstring + " of " + total + " entries"
                    }
                });
                paginationNumbers.appendChild(pageNumber);
                var tbdy = document.createElement('tbody');

            };



        }
    })
    document.getElementById("search button").onclick = function () {
        var search = document.getElementById("searchusers").value
        $.ajax({
            url: 'https://smartgarbagecot.me/api/profile/search/' + search,
            type: 'GET',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
                'Authorization': Authorizationheader
            },
            success: function (data) {
                console.log('Load was performed.');
                var tbdy = document.createElement('tbody');
                var tbl = document.getElementById("mytable")
                for (var j = tbl.rows.length - 1; j > 0; j--) {
                    document.getElementById("mytable").deleteRow(j);
                }
                for (var i = 0; i < data.length; i++) {
                    var tr = document.createElement('tr');
                    var role;
                    if (data[i].permissionLevel == 1) {
                        role = "Surfer"

                    } else {
                        role = "Admin"
                    }
                    var block = [i + 1, data[i].mail, data[i].fullname, role]
                    for (var j = 0; j < 4; j++) {

                        var td = document.createElement('td');
                        td.innerHTML = block[j]
                        tr.appendChild(td)

                    }
                    tbdy.appendChild(tr);
                }
                tbl.appendChild(tbdy);
                var division = Math.floor(data.length / 5) + 1
                divisionstring = division.toString();
                var total = data.length.toString();
                document.getElementById("numentries").innerHTML = "Showing " + buttonindex + " to " + divisionstring + " of " + total + " entries"
            }
        })
    }

});
var accesstoken = localStorage.getItem("accesstoken")
var mail = localStorage.getItem("mail")
var Authorizationheader = "Bearer " + accesstoken
console.log(accesstoken)
$.ajax({
    url: 'https://smartgarbagecot.me/api/profile/admin/2',
    type: 'GET',
    headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': Authorizationheader
    },
    success: function (data) {
        console.log('Load was performed.');
        console.log(data)
        document.getElementById("admins").innerHTML = data.length
    }
})
$.ajax({
    url: 'https://smartgarbagecot.me/api/profile/admin/1',
    type: 'GET',
    headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': Authorizationheader
    },
    success: function (data) {
        console.log('Load was performed.');
        console.log(data)
        document.getElementById("users").innerHTML = data.length
    }
})
$.ajax({
    url: 'https://smartgarbagecot.me/api/sensor',
    type: 'GET',
    headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': Authorizationheader
    },
    success: function (data) {
        console.log('Load was performed.');
        console.log(data)
        document.getElementById("sensors").innerHTML = data.length
    }
})
$.ajax({
    url: 'https://smartgarbagecot.me/api/profile/' + mail,
    type: 'GET',
    headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': Authorizationheader
    },
    success: function (data) {
        console.log('Load was performed.');
        console.log(data)
        document.getElementById("displayname").innerHTML = data.fullname
    }
})