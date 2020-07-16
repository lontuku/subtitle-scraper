document.addEventListener('DOMContentLoaded', function () {
    var name = document.getElementById('name')
    var loading = document.getElementsByTagName('h1')[0]
    name.addEventListener('input', update)

            var dropzone = document.getElementById('dropzone')

            dropzone.ondrop = function (e) {
                e.preventDefault()
                this.className = 'dropzone'
                update(e.dataTransfer.files[0].name)
            }

            dropzone.ondragover = function () {
                this.className = 'dropzone dragover'
                return false
            }

            dropzone.ondragleave = function () {
                this.className = 'dropzone'
                return false
            }

    function update(n) {
        
        if (name.files[0] != null){
            var dataName = name.files[0].name
        }
        else {
            var dataName = n
        }
        loading.innerHTML = `BUSCANDO...${dataName}`
        var url = 'http://localhost:3000/hola'
       
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
                var row = ""
                var answer = document.getElementById('answer')
                var keys = document.getElementById('keys')
                ele.append(document.createTextNode(response.name))
                list.prepend(ele)
                if (response.ans.length == 0){
                    loading.innerHTML = 'No fue posible encontrar subtítulos'
                    answer.innerHTML = ''

                }
                else {
                    keys.innerHTML = `Claves [${response.searchkeys}]`
                
                response.ans.forEach((elem, i) => {

                    row += `<tr>
                        <th scope="row">${i}</th>
                        <td class="text-center">[${elem.array}]</td>
                        <td class="text-center">${elem.percentage}%</td>
                        <td class="text-center">${elem.downloads}</td>
                        <td class="text-center"> <a class= "btn btn-info" href="${elem.links}">Bajar</a></td>
                        </tr>`
                })
                table = `<table class="table table-striped">
                        <thead class= "thead-dark">
                        <tr>
                            <th scope="col">#</th>
                            <th scope="col" class="text-center">Claves Encontradas</th>
                            <th scope="col" class="text-center">Porcentaje</th>
                            <th scope="col" class="text-center">Descargas</th>
                            <th scope="col" class="text-center">Link</th>
                        </tr>
                        </thead>
                        <tbody>
                            ${row}
                        </tbody>
                        </table>`
                answer.innerHTML = table
            }
                answer.innerHTML += '<button class="btn btn-info" onclick="location.reload()">Regresar</button>'

            })
            .then((response) => {
                //location.reload()

            })
    }
})

