SMarkUp.conf.bbcode = {
	markup: [
		SMarkUp.addons.searchAndReplace,
		{separator: true},
		{
			name: 'bold',
			className: 'strong',
			title: 'Negrita',
			open: '[b]',
			key: 'B',
			close: '[/b]'
		},
		{
			name: 'italic',
			className: 'em',
			title: 'Italica',
			className: 'em',
			open: '[i]',
			close: '[/i]'
		},
		{
			name: 'underline',
			title: 'Subrrallar',className: 'uli',
			open: '[u]',
			close: '[/u]'
		},
		{separator: true},
		{
			name: 'h1',
			title: 'Heading 1',
			open: '[h1]',
			close: '[/h1]',
			prepend: "\n",
			placeholder: 'Heading 1'
		},
		{
			name: 'h2',
			title: 'Heading 2',
			open: '[h2]',
			close: '[/h2]',
			prepend: "\n"
		},
		{
			name: 'h3',
			title: 'Heading 3',
			open: '[h3]',
			close: '[/h3]',
			prepend: "\n"
		},
		{
			name: 'h4',
			title: 'Heading 4',
			open: '[h4]',
			close: '[/h4]',
			prepend: "\n"
		},
		{
			name: 'h5',
			title: 'Heading 5',
			open: '[h5]',
			close: '[/h5]',
			prepend: "\n"
		},
		{
			name: 'h6',
			title: 'Heading 6',
			open: '[h6]',
			close: '[/h6]',
			prepend: "\n"
		},
		{separator: true},
		{
			name: 'img',
			title: 'Imagen',
			open: '[img]{url}',
			close: '[/img]',
			attributes: [
				{
					type: 'text',
					name: 'url',
					label: 'Image URL'
				}
			]
		},
		{
			name: 'url',
			className: 'a',
			title: 'Link',
			open: '[url={url}]',
			close: '[/url]',
			attributes: [
				{
					type: 'text',
					name: 'url',
					label: 'Link URL'
				}
			]
		},
		{separator: true},
		{
			name: 'ul',
			title: 'Unordered List',
			open: '[list]',
			close: '[/list]',
			prepend: "\n",
			append: "\n",
			wrapSelection: "\n[*]{selection}\n"
		},
		{
			separator: true	
		},
		{
			name: 'quote',
			className: 'blockquote',
			open: '[quote]',
			close: '[/quote]'
		},
		{
			name: 'code',
			open: '[code]',
			close: '[/code]'
		},
		{
			separator: true	
		},
		{
			name: 'form',
			className: 'text-indent',
			title: 'Form',
			open: "[form={url};{name}]\nEste contenido no es visible.",
			close: '[/form][submit={name}]Enviar, este link se puede mover a cualquier lugar de el documento.[/submit]',
			attributes: [
				{
					type: 'text',
					name: 'url',
					label: 'URL POST'
				},
				{
					type: 'text',
					name: 'name',
					label: 'Nombre del formulario'
				}
			]
		},
		{
			name: 'campo',
			className: 'text-indent',
			title: 'Campo de formulatio',
			open: "[campo={name}]",
			close: '[/campo]',
			attributes: [
				{
					type: 'text',
					name: 'name',
					label: 'Nombre del campo'
				}
			]
		},
	]
};