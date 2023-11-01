package com.myweb.www.handler;

import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.apache.tika.Tika;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import com.myweb.www.domain.FileVO;

import lombok.extern.slf4j.Slf4j;
import net.coobird.thumbnailator.Thumbnails;

@Slf4j
@Component
public class FileHandler {
	private final String UP_DIR ="D:\\_myweb\\_java\\fileupload";
	
	public List<FileVO> uploadFiles(MultipartFile[] files){
		List<FileVO> flist = new ArrayList<>();
		//파일경로, fvo set, 파일저장 ... 
		//날짜를 폴더로 생성하여 그날그날 업로드 파일을 관리
		LocalDate date = LocalDate.now(); //localDate 객체
		String today = date.toString(); //2023-10-24
		today = today.replace("-", File.separator); //2023\10\24(win) 2023/10/24(linux, mac)  
		
		//D:\\_myweb\\_java\\fileupload\\2023\\10\\24
		File folders = new File(UP_DIR, today); 
		
		//폴더 생성
		if(!folders.exists()) {
			folders.mkdirs();
		}
		
		//files 객체에 대한 설정
		for(MultipartFile file : files) { //들어온 첨부파일 1개씩 for문 처리
			FileVO fvo = new FileVO();
			fvo.setSaveDir(today); 
			fvo.setFileSize(file.getSize());
			
			String originalFileName = file.getOriginalFilename();
			log.info(">>>> original "+originalFileName);
			String fileName = originalFileName.substring(
					originalFileName.lastIndexOf(File.separator)+1);
			log.info(">>>> fileName "+fileName);
			fvo.setFileName(fileName);
			
			UUID uuid = UUID.randomUUID();
			fvo.setUuid(uuid.toString());
			//기본 FileVO 생성 완료-------------------------------------
			
			//하단부터 디스크에 저장할 파일 객체 생성
			//파일이름 uuid_fileName  uuid_th_fileName
			String fullFileName = uuid.toString()+"_"+fileName;
			File storeFile = new File(folders, fullFileName);
			//file 객체가 저장이 되려면 첫 경로부터 다 설정이 되어 있어야함. 
			// D:\\_myweb\\_java\\fileupload\\2023\\10\\24\\uuid_filName.jpg
			
			try {
				file.transferTo(storeFile); //저장 
				//썸네일 생성 =>이미지 파일만 썸네일 생성
				//이미지 파일인 확인
				if(isImageFile(storeFile)) {
					fvo.setFileType(1); 
					//썸네일 생성
					File thumbNail = new File(folders, 
							uuid.toString()+"_th_"+fileName);
					Thumbnails.of(storeFile).size(75, 75).toFile(thumbNail);
				}
				
			}catch (Exception e) {
				// TODO: handle exception
				log.info(">>> file 생성 오류~!!");
				e.printStackTrace();
			}
			
			//flist에 fvo 추가
			flist.add(fvo);
		}

		return flist;
	}
	
	private boolean isImageFile(File storeFile) throws IOException {
		String mimeType = new Tika().detect(storeFile); //image/jpg
		return mimeType.startsWith("image")? true : false;
	}
}
