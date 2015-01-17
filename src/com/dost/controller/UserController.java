package com.dost.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.dost.hibernate.DbUser;
import com.dost.model.User;
import com.dost.model.UserPopulator;
import com.dost.service.UserService;

@Controller
@RequestMapping("api")
public class UserController {

	@Autowired
	UserService userService;
	
	/*messages received*/
	@RequestMapping(value="/users", method=RequestMethod.GET)  
	@ResponseBody
	public List<DbUser> getAllUsers(HttpServletRequest request) {
		String role = request.getParameter("role");
		if(role == null || role.length() == 0) {
			role = "ROLE_USER";
		}
		return userService.getAllUsers(role);
	}
	
	@RequestMapping(value="/user/{username}", method=RequestMethod.GET)  
	@ResponseBody
	public DbUser getUserByUsername(@PathVariable String username) {
		return userService.getUserByUsername(username);
	}
	
	@RequestMapping(value="/userdetail/add", method=RequestMethod.POST)  
	@ResponseBody
	public User addUserDetail(User user) {
		DbUser dbUser = userService.getUser(user.getUserId());
		dbUser.setFname(user.getFname());
		dbUser.setLname(user.getLname());
		dbUser.setHostel(user.getHostel());
		dbUser.setYear(user.getYear());
		dbUser.setBranch(user.getBranch());
		
		dbUser = userService.updateUser(dbUser);
		User userToReturn = new User();
		UserPopulator.populateUser(userToReturn, dbUser);
		return userToReturn;
	}
	
	@RequestMapping(value="users/count", method=RequestMethod.GET)  
	@ResponseBody
	public Map<String, Integer> getUserDetail() {
		int usersCount = userService.getUsersCount();
		Map<String, Integer> countMap = new HashMap<String, Integer>();
		countMap.put("count", usersCount);
		return countMap;
	}
	
	
}
