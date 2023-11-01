console.log(bnoVal);

async function postCommentToServer(cmtData) {
    try {
        const url = '/comment/post';
        const config = {
            method : 'post',
            headers : {
                'Content-Type':'application/json; charset=utf-8'
            },
            body : JSON.stringify(cmtData)
        };
        const resp = await fetch(url, config);
        const result = await resp.text();
        return result;
    } catch (error) {
        console.log(error);
    }
}
document.getElementById("cmtPostBtn").addEventListener('click',()=>{
    const cmtText = document.getElementById('cmtText');
    if (cmtText.value == null || cmtText.value =='') {
        alert('댓글 내용을 입력해주세요!');
        cmtText.focus();
        return false;
    } else {
        let cmtData ={
            bno : bnoVal,
            writer : document.getElementById('cmtWriter').innerText,
            content : cmtText.value
        };
        postCommentToServer(cmtData).then(result => {
            if (parseInt(result)) {
                alert("댓글 등록 성공~");
                document.getElementById('cmtText').value='';
            }
            getCommentList(cmtData.bno);
        });
    }
});

async function spreadCommentFromServer(bno, page){
    try{
        const resp = await fetch('/comment/'+bno+'/'+page);
        const result = await resp.json();
        return result;
    }catch(err){
        console.log(err);
    }
}

//무조건 첨을 뿌릴때는 첫페이지 값을 뿌려야 함.
function getCommentList(bno, page=1){
    spreadCommentFromServer(bno, page).then(result =>{
        console.log(result); //ph 객체 pgvo, totalCount, cmtList
        if(result.cmtList.length>0){
            const ul = document.getElementById('cmtListArea');
            //다시 댓글을 뿌릴때 기존 값 삭제  1page일 경우만
            if(page==1){
                ul.innerText="";
            }
            for(let cvo of result.cmtList){
                let li = `<li class="list-group-item" data-cno="${cvo.cno}" data-writer="${cvo.writer}">`;
                li+= `<div class="mb-3">`;
                li+= `<div class="fw-bold">${cvo.writer}</div>`;
                li+= `${cvo.content}`;
                li+= `</div>`;
                li+= `<span class="badge rounded-pill text-bg-dark">${cvo.modAt}</span>`;
                li+= `<button type="button" class="btn btn-outline-danger mod" data-bs-toggle="modal" data-bs-target="#myModal">e</button>`;
                li+= `<button type="button" class="btn btn-outline-warning del">x</button>`;
                li+= `</li>`;
                ul.innerHTML+=li;
            }

            //댓글 페이징 코드
            let moreBtn = document.getElementById('moreBtn');
            console.log(moreBtn);
            //db에서 pgvo + list 같이 가져와야 값을 줄 수 있음.
            if(result.pgvo.pageNo < result.endPage){
                moreBtn.style.visibility ='visible'; //버튼 표시
                moreBtn.dataset.page = page + 1;
            }else {
                moreBtn.style.visibility = 'hidden'; //버튼 숨김
            }

        }else{
            let li = `<li class="list-group-item">Comment List Empty</li>`;
            innerHTML = li;
        }
    })
}
async function eraseCommentAtServer(cno, writer) {
    try {
        const url = '/comment/del/'+cno+'/'+writer;
        const config = {
            method: 'delete'
        };
        const resp = await fetch(url, config);
        const result = await resp.text();
        return result;
    } catch (err) {
        console.log(err);
    }
}

document.addEventListener('click',(e)=>{
    if(e.target.classList.contains('del')){
        let li = e.target.closest('li');
        let cnoVal = li.dataset.cno;
        let writerVal = li.dataset.writer;
        console.log(writerVal);
        eraseCommentAtServer(cnoVal, writerVal).then(result=>{
            if(result ==1){
                alert('댓글삭제완료~!!');
                getCommentList(bnoVal);
            }else if(result ==0){
            	alert('작성자가 일치하지 않습니다.');
            }
        })
    }else if(e.target.classList.contains('mod')){
        let li = e.target.closest('li');
        //nextSibling() : 같은 부모의 다음 형제 객체를 반환
        let cmtText = li.querySelector('.fw-bold').nextSibling;

        //기존내용 모달창에 반영 (수정하기 편하게...)
        document.getElementById('cmtTextMod').value = cmtText.nodeValue;
        //cmtModBtn에 data-cno 달기
        document.getElementById('cmtModBtn').setAttribute('data-cno', li.dataset.cno);
        document.getElementById('cmtModBtn').setAttribute('data-writer', li.dataset.writer);
    }else if(e.target.id == 'cmtModBtn'){
        let cmtDataMod={
            cno :e.target.dataset.cno,
            writer :e.target.dataset.writer,
            content : document.getElementById('cmtTextMod').value
        };
        console.log(cmtDataMod);
        editCommentToServer(cmtDataMod).then(result => {
            if(parseInt(result)){
                // 모달창 닫기
                document.querySelector('.btn-close').click();
                
            }else {
            	alert('작성자가 일치하지 않습니다.');
            	// 모달창 닫기
                document.querySelector('.btn-close').click();
            }
            getCommentList(bnoVal);
        })
    }else if(e.target.id == 'moreBtn'){
        getCommentList(bnoVal, parseInt(e.target.dataset.page));
    }

})

async function editCommentToServer(cmtDataMod){
    try{
        const url = '/comment/'+cmtDataMod.cno;
        const config ={
            method: 'put',
            headers: {
                'Content-Type' : 'application/json; charset=utf-8'
            },
            body: JSON.stringify(cmtDataMod)
        };
        const resp = await fetch(url, config);
        const result = await resp.text();
        return result;
    }catch(err){
        console.log(err);
    }
}
