package com.myweb.www.handler;

import java.io.File;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.myweb.www.domain.FileVO;
import com.myweb.www.repository.FileDAO;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@AllArgsConstructor
@Component
@EnableScheduling
public class FileSweeper {

	private final String BASE_PATH = "D:\\_myweb\\_java\\fileupload\\";
	
	@Inject
	private FileDAO fdao;
	
	//초 분 시 일 월 요일 년도(생략가능)
	@Scheduled(cron = "0 0 21 * * *")
	public void fileSweeper() {
		log.info(">>>> FileSweeper Running Start : {} > "+ LocalDateTime.now());
		
		//DB에 등록된 파일 목록 가져오기
		List<FileVO> dbList = fdao.selectListAllFiles();
		
		//저장소를 검색할 때 필요한 파일 경로 리스트(실제 존재해야 될 리스트)
		List<String> currFiles = new ArrayList<String>();
		
		for(FileVO fvo : dbList) {
			String filePath = fvo.getSaveDir()+"\\"+fvo.getUuid();
			String fileName = fvo.getFileName();
			currFiles.add(BASE_PATH + filePath + "_" + fileName);
			
			//이미지파일이면 썸네일도 경로 추가
			if(fvo.getFileType() > 0) {
				currFiles.add(BASE_PATH + filePath + "_th_" + fileName);
			}
		}
		log.info("currFiles >>> "+ currFiles);
		
		//날짜를 반영한 폴더 구조 경로 만들기
		LocalDate now = LocalDate.now();
		String today = now.toString();
		today = today.replace("-", File.separator);
		
		//경로를 기반으로 저장되어있는 파일을 검색
		File dir = Paths.get(BASE_PATH + today).toFile();
		File[] allFileObjects = dir.listFiles();
		
		//실제 저장되어 있는 파일과 DB에 존재햐는 파일을 비교하여 없는 삭제 진행
		for(File file : allFileObjects) {
			String storedFileName = file.toPath().toString();
			if(!currFiles.contains(storedFileName)) {
				file.delete(); //파일삭제
				log.info(">>>>> delete File > {} >> "+ storedFileName);
			}
		}
		log.info(">>>> FileSweeper Running Finish : {} > "+ LocalDateTime.now());
	}
}
