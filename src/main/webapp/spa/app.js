var list = {
	templateUrl: 'tpl/index.html',
	dataUrl: 'api/index.jsp',
	submit: function(f) {
		alert('회원 검색폼 서브밋');
	}
};

var edit = {
	templateUrl: 'tpl/edit.html',
	dataUrl: 'api/edit.jsp',
	success: function(ret) {
		location.href = '#/list';
	}
}

var view = {
	templateUrl: 'tpl/view.html',
	dataUrl: 'api/view.jsp'
}

var add = {
	templateUrl: 'tpl/add.html',
	dataUrl: 'api/add.jsp',
	success: function(ret) {
		location.href = '#/list';
	}
}

var del = {
	templateUrl: 'tpl/delete.html',
	dataUrl: 'api/delete.jsp',
	success: function(ret) {
		location.href = '#/list';
	}
};

var logout = {
	dataUrl: 'api/logout.jsp',
	after: function(ret) {
		location.href = 'login.html';
	}
};
var menu = {
	templateUrl: 'tpl/delete.html',
	dataUrl: 'api/logout.jsp',

};

var app1 = {
	templateUrl:'/spa/tpl/menu/form.html',
	dataUrl: '/spa/api/menu/index.jsp',

};

$(document).ready(function() {
	$('#main').router({
		routes: {
			'/': list,
			'/list': list,
			'/edit': edit,
			'/view': view,
			'/add': add,
			'/del': del,
			'/logout': logout,
			'/admin/menu': app1,

		},
		error: function(ret) {
			if(ret.error == 100) {
				location.href = 'login.html';
			} else {
				alert(ret.message);
			}
		}
	});

});