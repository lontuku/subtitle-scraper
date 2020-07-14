document.addEventListener('DOMContentLoaded', function () {
    var name = document.getElementById('name')
    var loading = document.getElementsByTagName('h1')[0]
    name.addEventListener('input', update)
    function update(n) {
        
        
        var dataName = name.files[0].name
        loading.innerHTML = `BUSCANDO...${dataName}`
        var url = 'https://whispering-plains-51052.herokuapp.com/hola'
        var data = { name: `${dataName}` }

        fetch(url, {
            method: 'POST', // or 'PUT'
            body: JSON.stringify(data), // data can be `string` or {object}!
            headers: {
                'Content-Type': 'application/json'
            }
        }).then(res => res.json())
            .catch(error => console.error('Error:', error))
            .then(response => {
                console.log('Success:', response)
                loading.innerHTML = 'ENCONTRADO:'

                list = document.getElementById('lista')
                var ele = document.createElement('li')
                var links = ""
                var answer = document.getElementById('answer')
                ele.append(document.createTextNode(response.name))
                list.prepend(ele)

                response.ans.forEach((elem) => {
                    
                    links += `<p>Este subtítulo se acerca en un ${elem.percentage}% a tu archivo, y ha sido descargado ${elem.downloads} veces. <a href="${elem.links}">Descargar</a></p>`
                    console.log(elem)
                    //cards += card(elem.name, elem.url)
                })
                answer.innerHTML = links

                //list.innerHTML += `<li>${response.name}</li>`
            })
            .then((response) => {
                //location.reload()

            })
    }
})