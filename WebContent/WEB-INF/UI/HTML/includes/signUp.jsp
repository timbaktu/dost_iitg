<div class="col-md-3" >
	<div class="login_unit right_unit">
		<p>Is something bothering you? Feeling lonely/uninterested?</p>
		<p>I are here to support you and help you in any way we can. I will listen to all your problems - think of me as your friend who would be there for you when you need him</p>
		<div class="signupLoginOption">
			<p><a href="signupNow" class="btn btn-primary btn-large signup_now">SIGNUP NOW</a></p>
			<a href="login" class="login_acc">Login to your account</a></p> 
			<p class="counter" id="counter"></p>
		</div>
	</div>
	<script src="//code.jquery.com/ui/1.11.2/jquery-ui.js"></script>
	<script>
		$(document).ready(function(){
			$.getJSON('/dost/api/users/count', function(count) {
				$("#counter").append(count.count + ' people already seeking help from special friends!');
			});
		});
	</script>
</div>