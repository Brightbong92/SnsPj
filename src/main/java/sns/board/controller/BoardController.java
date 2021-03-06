package sns.board.controller;



import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;
import sns.board.service.BoardService;
import sns.domain.Follow;
import sns.domain.Member;
import sns.vo.BoardLikeVo;
import sns.vo.BoardListResult;
import sns.vo.InsertBoardVo;

@Log4j
@RequestMapping("board")
@Controller
@AllArgsConstructor
public class BoardController {
	
	BoardService boardService;

	final long PS = 3;
	
	@RequestMapping(value = "list.do", method = RequestMethod.GET)
	public String boardList(HttpSession session, Model model, String mem_email) {
		long cp = 1;
		Member m = (Member)session.getAttribute("loginUser");
		mem_email = m.getMem_email();
		BoardListResult boardListResult = boardService.getBoardListResult(cp, PS, mem_email);
		model.addAttribute("boardListResult", boardListResult);
		return "board/list";
	}
	@GetMapping("infinityList.do")
	@ResponseBody
	public BoardListResult infinityList(long cp, HttpSession session) {
		String mem_email = getClientEmail(session);
		return boardService.getBoardListResult(cp, PS, mem_email);
	}
	
	
	@PostMapping("likeAjax.do")
	@ResponseBody
	public BoardLikeVo likeAjax(String str) {
		String[] strs = str.split(",");
		String cmd = strs[0];
		String b_seqStr = strs[1]; long b_seq = Integer.parseInt(b_seqStr);
		String mem_email = strs[2]; //log.info("#cmd: " + cmd);
		BoardLikeVo boardLikeVo = boardService.likePlusMinus(b_seq, mem_email, cmd);
		return boardLikeVo;
	}
	
	@RequestMapping(value ="searchList.do", method=RequestMethod.GET)
	public ModelAndView boardSearch(String keyword, HttpSession session) {
		String mem_email = getClientEmail(session);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("board/search_list");
		mv.addObject("userSearchListResult", boardService.getUserSearchListResult(keyword, mem_email));
		return mv;
	}
	
	private String getClientEmail(HttpSession session) {
		Member m = (Member)session.getAttribute("loginUser");
		String mem_email = m.getMem_email();
		return mem_email;
	}
	
	@RequestMapping(value="follow.do", method=RequestMethod.POST)
	@ResponseBody
	public String userFollow(@RequestBody String flr_email, HttpSession session) {
		String mem_email = getClientEmail(session);
		boardService.insertFollowingS(new Follow(flr_email, mem_email));
		return "follow";
	}
	@RequestMapping(value="unfollow.do", method=RequestMethod.POST)
	@ResponseBody
	public String userUnfollow(@RequestBody String flr_email, HttpSession session) {
		String mem_email = getClientEmail(session);
		boardService.deleteFollowingS(new Follow(flr_email, mem_email));
		return "unfollow";
	}
	@RequestMapping(value="/board_create_form.do", method=RequestMethod.GET)
	public String boardCreateForm() {
		return "board/create_form";
	}
	@RequestMapping(value="fileUpload.do")
	public void fileUpload(Model model, HttpServletResponse response, @RequestParam("Filedata") MultipartFile Filedata) {
	   	SimpleDateFormat df = new SimpleDateFormat("yyyyMMddHHmmssSSS");
	   	String newfilenameTime = df.format(new Date()) + Integer.toString((int) (Math.random()*10));
	   	
	   	String ofname = Filedata.getOriginalFilename();
	   	StringBuffer sb = new StringBuffer();
	   	sb.append(newfilenameTime); sb.append("_"); sb.append(ofname);  
	   	
		File f = new File(FilePath.FILE_STORE + sb.toString());

		try {
			response.setContentType("text/html;charset=UTF-8");
			Filedata.transferTo(f);
		   	response.getWriter().write(sb.toString());
			//response.getWriter().print(sb.toString());
		} catch (IllegalStateException | IOException e) {
			e.printStackTrace();
		}
	}

	@PostMapping("boardUpload.do")
	public String boardUpload(HttpServletRequest request, HttpSession session, Model model) throws Exception{
		String mem_email = getClientEmail(session);
		//request.setCharacterEncoding("utf-8");
		String b_content = request.getParameter("b_content");
		String filename = request.getParameter("filename");
		String realname = request.getParameter("realname");
		String filesize = request.getParameter("filesize");
    	String[] sizelist = realname.split(",");//파일사이즈
    	String[] ofilelist = filename.split(",");//오리지날파일이름
    	String[] filelist = filesize.split(",");//저장되는파일이름
    	for(int i = 0; i<=filelist.length-1; i++) {
    		log.info("#ofilelist: " + ofilelist[i]);
    		log.info("#filelist: " + filelist[i]);
    	}
    	BoardListResult boardListResult = boardService.insertBoardS(new InsertBoardVo(mem_email, b_content, ofilelist, filelist, sizelist));
//    	model.addAttribute("boardListResult", boardListResult);
//    	return "redirect:/board/my_board_list.do";
    	return "board/board_create_msg";
    	//return "board/upload_save";
	}
	
	@GetMapping("my_board_list.do")
	public String myBoardList(HttpSession session, Model model) {
		String mem_email = getClientEmail(session);
		long cp = 1;
		BoardListResult boardListResult = boardService.getMyBoardListResult(cp, PS, mem_email);//selectMyBoardS 만들어야함.
		model.addAttribute("boardListResult", boardListResult);
		return "board/my_board_list";
	}
	
	@GetMapping("infinityMyBoardList.do")
	@ResponseBody
	public BoardListResult infinityMyBoardList(long cp, HttpSession session) {
		String mem_email = getClientEmail(session);
		return boardService.getMyBoardListResult(cp, PS, mem_email);
	}
	@RequestMapping(value="my_info.do", method=RequestMethod.GET)
	public String myProfile(HttpSession session, Model model) {
		String mem_email = getClientEmail(session);
		Member member = boardService.selectMemberS(mem_email);
		model.addAttribute("member", member);
		return "board/my_info";
	}
	
	@PostMapping("my_info_change.do")
	public String myInfoChange(MultipartFile profile_file, String before_profile_file, HttpSession session) {
		String mem_email = getClientEmail(session);
		if(!profile_file.getOriginalFilename().equals("")) {//프사 등록 시
			//log.info("#profile_file: " + profile_file.getOriginalFilename());
			File file = new File(FilePath.PROFILE_FILE_STORE, before_profile_file);
			//log.info("#기존프사: " + file.getName());
			if(file.getName().equals("defaultProfile.jpg")) {//기본프사 였을경우
				//log.info("기본프사 였는데 프사바꿀경우.");//기본프사는 지우지 않는다..
				String mem_profile = saveStore(profile_file);// 그리고 새로운 파일을 저장한다.
				boardService.updateProfileImageS(mem_email, mem_profile);
			}else {
				//log.info("기본프사 아닌데 프사바꿀경우.");
				file.delete();//그전 프사파일은 지운다.
				String mem_profile = saveStore(profile_file);//그리고 새로운파일을 저장한다.
				boardService.updateProfileImageS(mem_email, mem_profile);
			}

		}else {//프사 등록 아닐 시
			
		}
		Member member = boardService.selectMemberS(mem_email);
		session.setAttribute("loginUser", member);
		return "board/my_info_msg";
	}
	
	private String saveStore(MultipartFile f) {
		//log.info("#service saveStore() f: " + f);
		String ofname = f.getOriginalFilename();
		int idx = ofname.lastIndexOf(".");
		String ofheader = ofname.substring(0, idx); 
		String ext = ofname.substring(idx);
		
		long fsize = f.getSize();
		long ms = System.currentTimeMillis();	
		String fname = ofheader + "_" + ms + ext;
		StringBuilder sb = new StringBuilder();
		sb.append(ofheader);
		sb.append("_");
		sb.append(ms);
		sb.append(ext);
		String saveFileName = sb.toString();
		//log.info("ofname: " + ofname + ", ext: " + ext + ", fsize: " + fsize);
		//log.info("ofname: " + ofname + ", fname: " + fname);
		//log.info("ofname: " + ofname + ", fname: " + saveFileName);
		
		boolean flag = writeFile(f, saveFileName);
		if(flag) {
			log.info("파일출력성공");
		}else {
			log.info("파일출력실패");
		}
		
		return fname;
	}

	private boolean writeFile(MultipartFile f, String saveFileName) {
		//log.info("#service writeFile() f: " + f + ", saveFileName: " + saveFileName);
		
		File rDir = new File(FilePath.PROFILE_FILE_STORE);
		if(!rDir.exists()) {
			rDir.mkdirs();
		}
		
		FileOutputStream fos = null;
		try {
			byte data[] = f.getBytes();
			fos = new FileOutputStream(FilePath.PROFILE_FILE_STORE + saveFileName);
			fos.write(data);
			fos.flush();
			return true;
		}catch(IOException ie) {
			return false;
		}finally {
			try {
				if(fos != null) fos.close();
			}catch(IOException ie) {
			}
		}
	}
	
}