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
            let heading_4 = document.createElement('th');
            heading_4.innerHTML = "Action";
            row_1.appendChild(heading_0);
            row_1.appendChild(heading_1);
            row_1.appendChild(heading_2);
            row_1.appendChild(heading_3);
            row_1.appendChild(heading_4);

            thead.appendChild(row_1);

            var tbdy = document.createElement('tbody');
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
            body.appendChild(tbl)
            let trr = document.querySelectorAll("table tbody tr");

Array.from(trr).forEach(function(trArray,index) {
    if (data[index].permissionLevel==1){
    console.log(index)
    let button = document.createElement("button");
    let td = document.createElement("td");
    button.innerText = "delete";
    button.setAttribute("id", index);
    button.addEventListener('click', function handleClick(event) {
        var tbl = document.getElementById("mytable")
        document.getElementById("mytable").deleteRow(event.srcElement.id)
        var mail=data[index].mail
        $.ajax({
            url: 'https://smartgarbagecot.me/api/profile/' + mail,
            type: 'DELETE',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
                'Authorization': Authorizationheader
            },
            success: function (data) {
                console.log('Load was performed.');
                
            }
        })

    })
    td.append(button);
    trArray.append(td);
    }
});
            



        }
    })

});
var accesstoken = localStorage.getItem("accesstoken")
var mail = localStorage.getItem("mail")
var Authorizationheader = "Bearer " + accesstoken
console.log(accesstoken)


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