import React from 'react';
import Doctor from '../Doctor';

interface Props {
    label: string;
    items: any[];
}

const Container: React.FC<Props> = ({ label, items }) => {
    return items.length ? (
        <div className='doctors-content'>
            <div className='doctors-header'>
                <h1>{label}</h1>
            </div>
            <div className='doctors-list'>
                {items.map((item: any, index: number) => (
                    <Doctor data={item} key={index} />    
                ))}
            </div>
        </div>
    ) : null;
}

export default Container;
