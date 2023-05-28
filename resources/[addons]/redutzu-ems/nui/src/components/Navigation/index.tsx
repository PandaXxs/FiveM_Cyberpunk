import React from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import { Trans, useTranslation } from 'react-i18next';
import { fetchNui } from '../../utils/misc';

import Logo from '../../assets/logo.png';
import './styles.scss';

interface Link {
    id: string;
    label: string;
    icon: string;
    disabled: boolean;
}

const Navigation: React.FC<{ links: Link[] }> = ({ links }) => {
    const { t } = useTranslation('translation');

    const location = useLocation();
    const navigate = useNavigate();

    return (
        <aside className='navigation'>
            <div className='logo'>
                <img src={Logo} alt='Logo' />
            </div>
            <ul className='links'>
                {
                    links
                    .filter(link => !link.disabled)
                    .map((link, index) => (
                        <li 
                            key={index}
                            className={`link ${link.id === location.pathname ? 'active' : ''}`}
                            onClick={() => {
                                if (location.pathname === link.id) return;
                                return navigate(link.id)
                            }}
                        >
                            <div className='icon'>
                                <i className={link.icon}></i>
                            </div>
                            <small><Trans t={t}>pages.{link.label}</Trans></small>
                        </li>
                    ))
                }
            </ul>
            <ul className='links'>
                <li className='link' onClick={() => fetchNui('hide')}>
                    <div className='icon'>
                        <i className='fas fa-sign-out-alt'></i>
                    </div>
                    <small><Trans t={t}>words.exit</Trans></small>
                </li>
            </ul>
        </aside>
    )
}
  
export default Navigation;
  