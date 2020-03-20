package sns.board.mapper;

import java.util.List;
import java.util.Map;

import sns.domain.Board;
import sns.domain.Board_File;
import sns.domain.Board_Like;
import sns.domain.Board_Reply;
import sns.domain.Follow;
import sns.domain.Member;

public interface BoardMapper {
	List<Board> selectBoard(Map map);
	List<Board_File> selectBoardFile(long b_seq);
	List<Board_Reply> selectBoardReply(Map map);
	String selectMemberProfile(String mem_email);
	long selectBoardTotalCount(String mem_email);
	long selectBoardLikeCount(long b_seq);
	List<Board_Like> selectBoardLike(long b_seq);
	Board_Like selectBoardLikeUser(Board_Like board_like);
	void insertBoardLike(Board_Like board_like);
	void deleteBoardLike(Board_Like board_like);
	long selectBoardReplyCount(long b_seq);
	List<Member> selectUser(String keyword);
	List<Follow> selectFollow(String mem_email);
	void deleteFollowing(Follow follow);
	void insertFollowing(Follow follow);
}
