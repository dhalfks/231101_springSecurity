console.log("boardModify.js");

async function remomveFileToServer(uuid){
    try{
        const url = '/board/file/'+uuid;
        const config ={
            method: 'delete'
        };
        const resp = await fetch(url, config);
        const result = await resp.text();
        return result;
    }catch(err){
        console.log(err);
    }
}

document.addEventListener('click',(e)=>{
    if(e.target.classList.contains('file-x')){
        remomveFileToServer(e.target.dataset.uuid).then(result =>{
            console.log(result);
            alert('파일삭제'+(parseInt(result)>0 ? '완료':'실패'));
            if(parseInt(result)){
                e.target.closest('li').remove();
                //location.reload();  //새로고침
            }
        })
    }
})