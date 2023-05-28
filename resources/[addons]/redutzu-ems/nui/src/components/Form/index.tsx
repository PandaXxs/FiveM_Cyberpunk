import React, { FormHTMLAttributes } from 'react';
import './styles.scss';

interface Props {
    label?: string;
    children: React.ReactNode;
}

const Form: React.FC<Props & FormHTMLAttributes<HTMLFormElement>> = settings => {
    return (
        <form {...settings}>
            { 
                settings.label ? 
                    <div className='header'>
                        <h1>{settings.label}</h1>
                    </div>
                : null
            }
            <div className='content'>
                {settings.children}
            </div>
        </form>
    );
}
  
export default Form;
  