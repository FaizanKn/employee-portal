window.login = (function(){
	"use strict";
	var pc = {};
	function handleHash(htmlInjector){
		
		prepareHtml.htmlInjector = htmlInjector;
		if(!prepareHtml.templateFunction){
			$.ajax({
				url: '/login-template',
				method: 'GET',
				dataType: 'text',
				data: {},
				success: getTemplateSH,
				error: function(){
					console.log(arguments);
				}
			});
		}
		else{
			prepareHtml();
		}		
	}	

	function getTemplateSH(source){
		prepareHtml.templateFunction = Handlebars.compile(source);
		prepareHtml({error:""});
	}

	function prepareHtml(errObj){
		if(prepareHtml.templateFunction){
			var content = prepareHtml.templateFunction(errObj);
			prepareHtml.htmlInjector(content,pageSetup);
		}
	}

	function showLoginError(){
		if(prepareHtml.templateFunction){
			//var content = prepareHtml.templateFunction({error:"Login Failed!"});
			//prepareHtml.htmlInjector(content,pageSetup);
			if(pc.username.val()=='')
			{
				$('.emptyEmail').css('display','block');
			}
			else if(pc.username.val().indexOf('@nagarro.com')==-1)
			{
				$('.wrongEmail').css('display','block');
			}
			else if(pc.password.val()=='')
			{
				$('.wrongPassword').css('display','block');	
			}
			else
			{
				$('.wrongCredentials').css('display','block');
				pc.password.val();
			}

		}
	}
	function loginSuccessHandler(data){
		if(!data.IsAuthenticated)
			showLoginError();
		else{
			
			window.location.href = '/';
		}
	}
	function loginHandler(){
		debugger;
		var loginId = pc.username.val();
		var pwd = pc.password.val();
		$.ajax({
				url: '/login',
				method: 'POST',
				data: {
					LoginId: loginId,
					Password: pwd
				},
				success: loginSuccessHandler				
			});
	}
	function clearUsernameError()
	{
		pc.wrongEmail.css('display','none');
		pc.emptyEmail.css('display','none');
	}
	function clearPasswordError()
	{
		pc.wrongPassword.css('display','none');
		pc.wrongCredentials.css('display','none');

	}
	function pageSetup(){
		pc.divLoginTemplate = $('#divLoginTemplate');
		pc.username = $('#username',pc.divLoginTemplate);
		pc.password = $('#password',pc.divLoginTemplate);
		pc.login = $('#login',pc.divLoginTemplate);
		pc.emptyEmail=$('.emptyEmail',pc.divLoginTemplate);
		pc.wrongEmail=$('.wrongEmail',pc.divLoginTemplate);
		pc.wrongPassword=$('.wrongPassword',pc.divLoginTemplate);
		pc.wrongCredentials=$('.wrongCredentials',pc.divLoginTemplate);	
		pc.username.on('focus',clearUsernameError);
		pc.password.on('focus',clearPasswordError);
		pc.login.on('click',loginHandler);

	}

	function init(){
	}
	return{
		init:init,
		handleHash:handleHash
	};
})();